package com.example.shipconquest.repo

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.game.Game
import com.example.shipconquest.repo.jdbi.dbmodel.ShipPositionDBModel
import org.slf4j.Logger
import java.time.Duration
import java.time.Instant

interface GameRepository {
    val logger: Logger
    fun get(tag: String): Game?
    fun getVisitedPoints(tag: String, uid: String): List<Vector2>?
    fun createGame(game: Game)
    fun addVisitedPoint(tag: String, uid: String, point: Vector2)
    fun createVisitedPoint(tag: String, uid: String, point: Vector2)
    fun checkVisitedPointsExist(tag: String, uid: String): Boolean
    fun getShipPosition(tag: String, shipId: Int, uid: String): ShipPositionDBModel?
    fun createShipPosition(
        tag: String,
        uid: String,
        points: List<Vector2>,
        startTime: Instant?,
        duration: Duration?
    )

    fun updateShipPosition(
        tag: String,
        uid: String,
        shipId: Int,
        points: List<Vector2>,
        startTime: Instant?,
        duration: Duration?
    )

    fun deleteShipEntry(tag: String, shipId: String, uid: String)

    fun checkShipPathExists(
        tag: String,
        shipId: String,
        uid: String,
    ): Boolean
}