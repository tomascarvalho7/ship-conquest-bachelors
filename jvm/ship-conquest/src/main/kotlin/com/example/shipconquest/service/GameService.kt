package com.example.shipconquest.service

import com.example.shipconquest.controller.model.output.Vector2OutputModel
import com.example.shipconquest.controller.model.output.ShipLocationOutputModel
import com.example.shipconquest.domain.*
import com.example.shipconquest.domain.path_finding.calculateEuclideanDistance
import com.example.shipconquest.domain.ship_navigation.CubicBezier
import com.example.shipconquest.domain.world.Horizon
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.getNearIslands
import com.example.shipconquest.domain.world.pulse
import com.example.shipconquest.left
import com.example.shipconquest.repo.TransactionManager
import com.example.shipconquest.repo.jdbi.dbmodel.toShipPath
import com.example.shipconquest.right
import com.example.shipconquest.service.result.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import java.text.SimpleDateFormat
import java.time.Duration
import java.time.LocalDateTime
import java.util.*
import kotlin.math.roundToInt
import kotlin.math.roundToLong

//take these out of here
const val chunkSize = 20.0
const val viewDistance = 10

@Service
class GameService(
    override val transactionManager: TransactionManager
) : ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun getChunks(tag: String, shipId: String, googleId: String): GetChunksResult {
        return transactionManager.run { transaction ->
            val staticPosition = transaction.gameRepo.getShipStaticPosition(tag, shipId, googleId)
            val coord: Vector2 = if (staticPosition != null) {
                staticPosition.toPosition().toVector2()
            } else {
                val path = transaction.gameRepo.getShipPath(tag, shipId, googleId)?.toShipPath()
                    ?: return@run left(GetChunksError.ShipPositionNotFound)
                val pos = path.getPositionFromTime().toVector2()
                if (pos == path.landmarks.last().p3) {
                    transaction.gameRepo.deleteShipEntry(tag, shipId, googleId) // vou mudar para um update depois
                    transaction.gameRepo.createShipStaticPosition(tag, shipId, googleId, pos)
                }
                pos
            }

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
            }
            else left(GetChunksError.GameNotFound)
        }
    }

    fun Game.inspectIslands(nearIslands: List<Island>) = buildList {
        for(island in nearIslands)
            addAll(map.pulse(
                origin = island.coordinate,
                radius = (island.radius / 1.8).roundToInt(),
                water = true
            ))
    }

    fun getPlayerStats(tag: String, uid: String): GetPlayerStatsResult {
        return transactionManager.run { transaction ->
            val lobby = transaction.lobbyRepo.get(tag = tag) ?: return@run left(GetPlayerStatsError.GameNotFound)
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = uid)
                ?: return@run left(GetPlayerStatsError.StatisticsNotFound)

            return@run right(value = playerStatistics)
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
            if (pointList.isEmpty()) return@run left(GetMinimapError.NoTrackedRecord)
            else right(pointList)
        }
    }

    fun navigate(tag: String, uid: String, shipId: String, points: List<Vector2>): NavigationResult {
        val startTime = LocalDateTime.now()
        var distance = 0.0;
        for (i in 0 until points.size - 1) {
            val a = points[i];
            val b = points[i + 1];
            distance += calculateEuclideanDistance(a, b)
        }
        val duration = Duration.ofSeconds((distance * 10).roundToLong())

        val formattedDuration = formatDuration(duration)

        if (!validateNavigationPath(buildBeziers(points))) {
            return left(NavigationError.InvalidNavigationPath)
        }

        return transactionManager.run { transaction ->
            transaction.gameRepo.deleteShipEntry(tag, shipId, uid)
            transaction.gameRepo.createShipPath(
                tag,
                shipId,
                uid,
                points,
                startTime,
                duration
            )
            right(ShipPathTime(startTime.toString(), formattedDuration))
        }
    }

    fun getShipLocation(tag: String, uid: String, shipId: String): GetShipLocationResult {
        return transactionManager.run { transaction ->
            val position = transaction.gameRepo.getShipStaticPosition(tag, shipId, uid)
            val path = transaction.gameRepo.getShipPath(tag, shipId, uid)

            if (position != null) {
                right(
                    ShipLocationOutputModel(
                        listOf(Vector2OutputModel(position.x, position.y)),
                        null,
                        null)
                )
            } else if (path != null) {
                right(
                    ShipLocationOutputModel(
                        path.landmarks.map { Vector2OutputModel(it.x, it.y) },
                        path.startTime.toString(),
                        formatDuration(path.duration)
                    )
                )
            } else {
                left(GetShipLocationError.ShipNotFound)
            }
        }
    }

    fun conquestIsland(tag: String, uid: String, shipId: String, islandId: Int): ConquestIslandResult {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag = tag)
                ?: return@run left(ConquestIslandError.GameNotFound)
            val island = transaction.islandRepo.get(tag = tag, islandId = islandId)
                ?: return@run left(ConquestIslandError.IslandNotFound)
            // TODO: update with canSightIsland
            if (false) return@run left(ConquestIslandError.ShipTooFarAway)

            val income = 25
            transaction.islandRepo.addOwnerToIsland(tag, uid, income, island)
            return@run right(
                OwnedIsland(
                    islandId = island.islandId,
                    coordinate = island.coordinate,
                    radius = island.radius,
                    uid = uid,
                    incomePerHour = income
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