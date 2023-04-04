package com.example.shipconquest.service

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.Vector3
import com.example.shipconquest.domain.world.pulse
import com.example.shipconquest.left
import com.example.shipconquest.repo.TransactionManager
import com.example.shipconquest.right
import com.example.shipconquest.service.result.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import kotlin.math.sqrt

//take these out of here
const val googleId = "117449194507120458325"
const val chunkSize = 35.0
const val viewDistance = 10
@Service
class GameService(
    override val transactionManager: TransactionManager
) : ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)


    fun getChunks(tag: String, x: Int, y: Int): GetChunksResult {
        val position = Position(x = x, y = y)

        return transactionManager.run { transaction ->
            val visitedPoints = transaction.gameRepo.getVisitedPoints(tag, googleId)
            if (visitedPoints == null) {
                transaction.gameRepo.createVisitedPoint(tag, googleId, position)
            }
            if(visitedPoints != null && visitedPoints.all { point -> getDistance(position, point) >= chunkSize }) {
                transaction.gameRepo.addVisitedPoint(tag, googleId, position)
            }
            val game = transaction.gameRepo.get(tag = tag)

            if (game != null) right(game.map.pulse(origin = position, radius = viewDistance))
            else left(GetChunksError.GameNotFound)
        }
    }

    fun getMinimap(tag: String, uid: String): GetMinimapResult {
        return transactionManager.run { transaction ->
            val visitedPoints = transaction.gameRepo.getVisitedPoints(tag, uid)
            val game = transaction.gameRepo.get(tag) ?: return@run left(GetMinimapError.GameNotFound)

            val pointList = visitedPoints?.flatMap { point ->
                val pulseResult = game.map.pulse(origin = point, radius = 35)
                pulseResult + Vector3(point.x, point.y, 0)
            }?.distinct()
                ?: emptyList()
            if (pointList.isEmpty()) return@run left(GetMinimapError.NoTrackedRecord)
            else right(pointList)
        }
    }

    // prob not needed rnº
    fun addVisitedPoint(tag: String, uid: String, position: Position) {
        return transactionManager.run { transaction ->
            if (!transaction.gameRepo.checkVisitedPointsExist(tag, uid)) {
                transaction.gameRepo.createVisitedPoint(tag, uid, position)
            } else {
                transaction.gameRepo.addVisitedPoint(tag, uid, position)
            }
        }
    }

    fun navigate(tag: String, points: List<Position>): NavigationResult {
        /*return transactionManager.run { transaction ->
            val areValid = true //validateNavigationPoints()
            if (areValid) {
                transaction.gameRepo.addNavigationPoints(points)
            } else {
            left(NavigationError.InvalidNavigationPath)
            }
        }*/
        return left(NavigationError.InvalidNavigationPath)
    }

    fun printMap(tag: String) {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag = tag) ?: return@run

            for (y in 0 until game.map.size) {
                for (x in 0 until game.map.size) {
                    val pos = Position(x = x, y = y)
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

fun getDistance(point1: Position, point2: Position): Double {
    val dx = (point2.x - point1.x).toDouble()
    val dy = (point2.y - point1.y).toDouble()
    return sqrt(dx * dx + dy * dy)
}