package com.example.shipconquest.service

import com.example.shipconquest.domain.*
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.game.Game
import com.example.shipconquest.domain.game.GameLogic
import com.example.shipconquest.domain.path_finding.calculateEuclideanDistance
import com.example.shipconquest.domain.ship_navigation.CubicBezier
import com.example.shipconquest.domain.ship_navigation.ship.Fleet
import com.example.shipconquest.domain.ship_navigation.ship.ShipBuilder
import com.example.shipconquest.domain.user.statistics.getCurrency
import com.example.shipconquest.domain.world.Horizon
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.getNearIslands
import com.example.shipconquest.domain.world.pulse
import com.example.shipconquest.left
import com.example.shipconquest.repo.TransactionManager
import com.example.shipconquest.right
import com.example.shipconquest.service.result.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import java.text.SimpleDateFormat
import java.time.Duration
import java.util.*
import kotlin.math.roundToInt

//take these out of here
const val chunkSize = 20.0
const val viewDistance = 10

@Service
class GameService(
    override val transactionManager: TransactionManager,
    val gameLogic: GameLogic
) : ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun getChunks(tag: String, shipId: String, googleId: String): GetChunksResult {
        return transactionManager.run { transaction ->
            val builder = transaction.shipRepo.getShipBuilder(tag, shipId.toInt(), googleId, gameLogic.getInstant())
                ?: return@run left(GetChunksError.ShipPositionNotFound)
            val coord = gameLogic.getCoordFromMovement(builder.movement)

            val visitedPoints = transaction.gameRepo.getVisitedPoints(tag, googleId)
            if (visitedPoints == null) {
                transaction.gameRepo.createVisitedPoint(tag, googleId, coord)
            }
            if (visitedPoints != null && visitedPoints.all { point ->
                    calculateEuclideanDistance(
                        coord,
                        point
                    ) >= chunkSize
                }) {
                transaction.gameRepo.addVisitedPoint(tag, googleId, coord)
            }

            val game = transaction.gameRepo.get(tag = tag) // TODO: can be optimized
            if (game != null) {
                val islands = transaction.islandRepo.getAll(tag = tag)
                val nearIslands = getNearIslands(coordinate = coord, islands = islands)
                right(
                    value = Horizon(
                        tiles = game.inspectIslands(nearIslands),
                        islands = nearIslands
                    )
                )
            } else left(GetChunksError.GameNotFound)
        }
    }

    fun Game.inspectIslands(nearIslands: List<Island>) = buildList {
        for (island in nearIslands)
            addAll(
                map.pulse(
                    origin = island.coordinate,
                    radius = (island.radius / 1.8).roundToInt(),
                    water = true
                )
            )
    }

    fun getPlayerStats(tag: String, uid: String): GetPlayerStatsResult {
        return transactionManager.run { transaction ->
            val lobby = transaction.lobbyRepo.get(tag = tag) ?: return@run left(GetPlayerStatsError.GameNotFound)
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = uid)
                ?: return@run left(GetPlayerStatsError.StatisticsNotFound)

            return@run right(value = gameLogic.buildPlayerStatistics(playerStatistics))
        }
    }

    fun getMinimap(tag: String, uid: String): GetMinimapResult {
        return transactionManager.run { transaction ->
            val visitedPoints = transaction.gameRepo.getVisitedPoints(tag, uid)
            val game = transaction.gameRepo.get(tag) ?: return@run left(GetMinimapError.GameNotFound)

            val pointList = visitedPoints?.flatMap { point ->
                val pulseResult = game.map.pulse(origin = point, radius = viewDistance, water = false)
                pulseResult + Vector3(point.x, point.y, 0)
            }?.distinct()
                ?: emptyList()

            right(value = Minimap(visitedPoints = pointList, size = game.map.size))
        }
    }

    fun navigate(tag: String, uid: String, shipId: Int, points: List<Vector2>): NavigationResult {
        val movement = gameLogic.buildShipMovement(points)
        if (!validateNavigationPath(movement.landmarks)) {
            return left(NavigationError.InvalidNavigationPath)
        }

        return transactionManager.run { transaction ->
            // delete future events since ship path has changed
            transaction.eventRepo.deleteShipEventsAfterInstant(tag = tag, sid = shipId, instant = movement.startTime)
            transaction.shipRepo.updateShipPosition(
                tag,
                uid,
                shipId,
                points,
                movement.startTime,
                movement.duration
            )
            // get all islands
            val islands = transaction.islandRepo.getAll(tag)
            val islandEvents = gameLogic.findIslandEvents(movement, islands) { instant, islandId ->
                transaction.eventRepo.createIslandEvent(tag, instant, IslandEvent(shipId, islandId))
            }
            val shipBuilder = ShipBuilder(id = shipId, movement = movement, events = islandEvents)
            right(gameLogic.buildShip(shipBuilder))
        }
    }

    fun getShip(tag: String, uid: String, shipId: Int): GetShipResult {
        return transactionManager.run { transaction ->
            val builder = transaction.shipRepo.getShipBuilder(tag, shipId, uid, gameLogic.getInstant())
                ?: return@run left(GetShipError.ShipNotFound)

            return@run right(
                value = gameLogic.buildShip(builder = builder)
            )
        }
    }

    fun getShips(tag: String, uid: String): GetShipsResult {
        return transactionManager.run { transaction ->
            val shipsBuilder = transaction.shipRepo.getShipsBuilder(tag = tag, uid = uid, gameLogic.getInstant())

            return@run right(
                value = Fleet(
                    ships = shipsBuilder.map { builder -> gameLogic.buildShip(builder = builder) }
                )
            )
        }
    }

    fun conquestIsland(tag: String, uid: String, shipId: String, islandId: Int): ConquestIslandResult {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag = tag)
                ?: return@run left(ConquestIslandError.GameNotFound)
            val island = transaction.islandRepo.get(tag = tag, islandId = islandId)
                ?: return@run left(ConquestIslandError.IslandNotFound)
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = uid)
                ?: return@run left(ConquestIslandError.PlayerStatisticsNotFound)
            // TODO: update with canSightIsland
            if (false) return@run left(ConquestIslandError.ShipTooFarAway)

            return@run right(
                value = gameLogic.conquestIsland(
                    uid = uid,
                    island = island,
                    onWild = { _, newIsland ->
                        // add ownership of island and take cost from currency
                        transaction.islandRepo.wildToOwnedIsland(tag = tag, island = newIsland)
                        transaction.statsRepo.updatePlayerCurrency(
                            tag = tag,
                            uid = uid,
                            instant = newIsland.conquestDate,
                            newStaticCurrency = playerStatistics.income.staticCurrency - 100
                        )
                    },
                    onOwned = { oldIsland, newIsland ->
                        // update previous owner of island currency
                        val oldOwner = transaction.statsRepo.getPlayerStats(tag = tag, uid = oldIsland.uid)
                        if (oldOwner != null)
                            transaction.statsRepo.updatePlayerCurrency(
                                tag = tag,
                                uid = oldOwner.uid,
                                instant = newIsland.conquestDate,
                                newStaticCurrency = oldOwner.income.getCurrency(newIsland.conquestDate)
                            )

                        // add ownership of island and take cost from currency
                        transaction.islandRepo.updateOwnedIsland(tag = tag, island = newIsland)
                        transaction.statsRepo.updatePlayerCurrency(
                            tag = tag,
                            uid = uid,
                            instant = newIsland.conquestDate,
                            newStaticCurrency = playerStatistics.income.getCurrency(newIsland.conquestDate) - 200
                        )
                    }
                )
            )
        }
    }

    fun printMap(tag: String) {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag = tag) ?: return@run

            for (y in 0 until game.map.size) {
                for (x in 0 until game.map.size) {
                    val pos = Vector2(x = x, y = y)
                    val tile = game.map.data[pos]?.div(10)

                    if (tile == null)
                        print("---")
                    else
                        print(tile.toString().padStart(2, '0') + '-')
                }
                println()
            }
        }
    }
}

fun validateNavigationPath(landmarks: List<CubicBezier>): Boolean {
    //validate path
    return true
}

fun buildBeziers(points: List<Vector2>): List<CubicBezier> {
    if (points.size % 4 != 0) return emptyList()

    return List(points.size / 4) { index ->
        CubicBezier(
            p0 = points[index * 4],
            p1 = points[(index * 4) + 1],
            p2 = points[(index * 4) + 2],
            p3 = points[(index * 4) + 3]
        )
    }
}

fun formatDuration(durationString: Duration): String {
    val durationMillis = durationString.toMillis()

    val dateFormat = SimpleDateFormat("mm:ss.SSS")
    dateFormat.timeZone = TimeZone.getTimeZone("UTC")

    return dateFormat.format(Date(durationMillis))
}