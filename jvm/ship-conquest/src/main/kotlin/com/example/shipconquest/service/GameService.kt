package com.example.shipconquest.service

import com.example.shipconquest.domain.*
import com.example.shipconquest.domain.bezier.BezierSpline
import com.example.shipconquest.domain.bezier.CubicBezier
import com.example.shipconquest.domain.bezier.utils.toVector2List
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.game.Game
import com.example.shipconquest.domain.game.logic.GameLogic
import com.example.shipconquest.domain.ship.*
import com.example.shipconquest.domain.ship.movement.Kinetic
import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.domain.user.statistics.getCurrency
import com.example.shipconquest.domain.world.Horizon
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.IslandList
import com.example.shipconquest.domain.world.islands.getCost
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
import java.time.Instant
import java.util.*
import kotlin.math.roundToInt

//take these out of here
const val chunkSize = 20.0
const val viewDistance = 15

@Service
class GameService(
    override val transactionManager: TransactionManager,
    val gameLogic: GameLogic
) : ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun getChunks(tag: String, shipId: Int, uid: String): GetChunksResult {
        return transactionManager.run { transaction ->
            val shipBuilder = gameLogic.getShipBuilder(
                tag = tag,
                uid = uid,
                sid = shipId,
                getShipInfo = transaction.shipRepo::getShipInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant
            ) ?: return@run left(GetChunksError.ShipPositionNotFound)
            val coord = gameLogic.getCoordFromMovement(gameLogic.buildShip(shipBuilder).movement)

            val game = transaction.gameRepo.get(tag = tag) // TODO: can be optimized
            if (game != null) {
                val islands = transaction.islandRepo.getAll(tag = tag, uid = uid)
                val nearIslands = getNearIslands(coordinate = coord, islands = islands)
                right(
                    value = Horizon(
                        voxels = game.inspectIslands(nearIslands),
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
            val game = transaction.gameRepo.get(tag) ?: return@run left(GetMinimapError.GameNotFound)
            // get user ships
            val userShips = transaction.shipRepo.getShipsInfo(tag, uid)
            val currInstant = gameLogic.getInstant()

            val islandsCenter = mutableListOf<Vector2>()
            val pathPoints = mutableListOf<Vector2>()
            // iterate in users ships
            for (ship in userShips) {
                // get ship path
                val events = transaction.eventRepo.getShipEvents(tag = tag, uid = uid, sid = ship.id)
                val builtMovements = ship.movements
                    .map { it.buildEvents(currInstant, events) }
                    .filterIsInstance<Kinetic>()
                // add trimmed movements to list of control points
                pathPoints.addAll(gameLogic.trimMovements(builtMovements))


                // filter island events TODO: eventRepo.getIslands(tag, uid)
                val islandEvents = events.filter { event ->
                    event.details is IslandEvent && event.instant.isBefore(gameLogic.getInstant())
                }
                for (event in islandEvents) {

                }
                transaction.eventRepo.getIslandEventsBeforeInstant(
                    tag = tag,
                    sid = ship.id,
                    uid = uid,
                    instant = currInstant
                ).map {
                    val details = it.details
                    if (details is IslandEvent) {
                        // get islands center coordinates
                        val islandCenter = transaction.islandRepo.get(tag = tag, uid = uid, islandId = details.island.islandId)
                        if (islandCenter != null) {
                            islandsCenter += islandCenter.coordinate
                        }
                    }
                }
            }

            // pulse island coordinates and add them to final response
            val islands = islandsCenter.flatMap { point ->
                game.map.pulse(origin = point, radius = viewDistance, water = true)
            }.distinct()

            // add paths to final response
            pathPoints.addAll(trimPaths(movements, currInstant).toVector2List())

            right(value = Minimap(paths = pathPoints, islands = islands, size = game.map.size))
        }
    }

    fun getKnownIslands(tag: String, uid: String): GetKnownIslandsResult {
        return transactionManager.run { transaction ->
            transaction.gameRepo.get(tag) ?: return@run left(GetKnownIslandsError.GameNotFound)

            right(
                value = IslandList(
                    islands = transaction.islandRepo.getVisitedIslands(tag = tag, uid = uid)
                )
            )
        }
    }

    fun navigate(tag: String, uid: String, shipId: Int, points: List<Vector2>): NavigationResult {
        val movement = gameLogic.buildMovementFromPoints(points) ?:
            return left(NavigationError.InvalidNavigationPath)

        return transactionManager.run { transaction ->
            val shipInfo = transaction.shipRepo.getShipInfo(tag = tag, shipId =  shipId, uid = uid)
                ?.addMovement(movement) ?: return@run left(NavigationError.ShipNotFound)
            // delete future events since ship path has changed
            transaction.eventRepo.deleteShipEventsAfterInstant(tag = tag, sid = shipId, instant = movement.startTime)
            transaction.shipRepo.updateShipInfo(
                tag,
                uid,
                shipId,
                movement
            )

            // get all islands
            val islands = transaction.islandRepo.getUnvisitedIslands(tag = tag, uid = uid)
            val islandEvents = gameLogic.buildIslandEvents(movement, islands) { instant, island ->
                transaction.eventRepo.createIslandEvent(tag, instant, IslandEvent(shipId, island))
            }
            val shipBuilder = ShipBuilder(info = shipInfo, events = islandEvents)
            val fleetBuilder = gameLogic.getFleetBuilder(
                tag = tag,
                uid = uid,
                getFleet = transaction.shipRepo::getOtherShipsInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant
            )
            val fightEvents = gameLogic.buildFightEvents(shipBuilder, fleetBuilder) { instant, details ->
                transaction.eventRepo.createFightingEvent(tag, instant, details)
            }
            right(gameLogic.buildShip(shipBuilder.addEvents(newEvents = fightEvents)))
        }
    }

    fun getShip(tag: String, uid: String, shipId: Int): GetShipResult {
        return transactionManager.run { transaction ->
            // check if game exists
            transaction.gameRepo.get(tag = tag) ?: return@run left(GetShipError.GameNotFound)
            val builder = gameLogic.getShipBuilder(
                tag = tag,
                uid = uid,
                sid = shipId,
                getShipInfo = transaction.shipRepo::getShipInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant
            )
                ?: return@run left(GetShipError.ShipNotFound)

            return@run right(
                value = gameLogic.buildShip(builder = builder)
            )
        }
    }

    fun getShips(tag: String, uid: String): GetShipsResult {
        return transactionManager.run { transaction ->
            // check if game exists
            transaction.gameRepo.get(tag = tag) ?: return@run left(GetShipsError.GameNotFound)
            val fleetBuilder = gameLogic.getFleetBuilder(
                tag = tag,
                uid = uid,
                getFleet = transaction.shipRepo::getShipsInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant

            )

            return@run right(
                value = Fleet(
                    ships = fleetBuilder.map { builder -> gameLogic.buildShip(builder = builder) }
                )
            )
        }
    }

    fun addShip(tag: String, uid: String): CreateShipResult {
        return transactionManager.run { transaction ->
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = uid)
                ?: return@run left(CreateShipError.PlayerStatisticsNotFound)
            val game = transaction.gameRepo.get(tag) ?: return@run left(CreateShipError.GameNotFound)

            // TODO create a good way to get ship costs
            val canBuy = gameLogic.makeTransaction(playerStatistics, 50) { newCurrency, instant ->
                transaction.statsRepo.updatePlayerCurrency(
                    tag = tag,
                    uid = uid,
                    instant = instant,
                    newStaticCurrency = newCurrency
                )
            }

            return@run if(canBuy != null) {
                val newShip = transaction.shipRepo.createShipInfo(tag, uid, gameLogic.generateRandomSpawnPoint(game.map), null, null)

                right(gameLogic.buildShip(ShipBuilder(newShip, emptyList())))
            } else {
                left(CreateShipError.NotEnoughCurrency)
            }
        }
    }

    fun conquestIsland(tag: String, user: User, shipId: String, islandId: Int): ConquestIslandResult {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag = tag)
                ?: return@run left(ConquestIslandError.GameNotFound)
            val island = transaction.islandRepo.get(tag = tag, uid = user.id, islandId = islandId)
                ?: return@run left(ConquestIslandError.IslandNotFound)
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = user.id)
                ?: return@run left(ConquestIslandError.PlayerStatisticsNotFound)
            // TODO: update with canSightIsland
            if (false) return@run left(ConquestIslandError.ShipTooFarAway)

            // make currency transaction
            gameLogic.makeTransaction(playerStatistics, island.getCost()) { newCurrency, instant ->
                transaction.statsRepo.updatePlayerCurrency(
                    tag = tag,
                    uid = user.id,
                    instant = instant,
                    newStaticCurrency = newCurrency
                )
            } ?: return@run left(ConquestIslandError.NotEnoughCurrency)

            val newIsland = gameLogic.conquestIsland(
                user = user,
                island = island,
                onWild = { _, newIsland ->
                    // add ownership of island and take cost from currency
                    transaction.islandRepo.wildToOwnedIsland(tag = tag, island = newIsland)
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
                }
            ) ?: return@run left(ConquestIslandError.AlreadyOwnedIsland)

            return@run right(
                value = newIsland
            )
        }
    }
}

fun validateNavigationPath(spline: BezierSpline): Boolean {
    //validate path
    return true
}

fun buildSpline(points: List<Vector2>): BezierSpline? {
    if (points.size % 4 != 0) return null

    return BezierSpline(segments = List(points.size / 4) { index ->
        CubicBezier(
            p0 = points[index * 4],
            p1 = points[(index * 4) + 1],
            p2 = points[(index * 4) + 2],
            p3 = points[(index * 4) + 3]
        )
    })
}

fun formatDuration(durationString: Duration): String {
    val durationMillis = durationString.toMillis()

    val dateFormat = SimpleDateFormat("mm:ss.SSS")
    dateFormat.timeZone = TimeZone.getTimeZone("UTC")

    return dateFormat.format(Date(durationMillis))
}
