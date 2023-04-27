package com.example.shipconquest.repo

import com.example.shipconquest.domain.Game
import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.ship_navigation.CubicBezier
import com.example.shipconquest.domain.ship_navigation.ShipPath
import com.example.shipconquest.domain.user.statistics.PlayerStats
import com.example.shipconquest.repo.jdbi.dbmodel.PositionDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.ShipPathDBModel
import org.slf4j.Logger
import java.time.Duration
import java.time.LocalDateTime

interface GameRepository {
    val logger: Logger
    fun get(tag: String): Game?
    fun getVisitedPoints(tag: String, uid: String): List<Vector2>?
    fun createGame(game: Game)
    fun addVisitedPoint(tag: String, uid: String, point: Vector2)
    fun createVisitedPoint(tag: String, uid: String, point: Vector2)
    fun checkVisitedPointsExist(tag: String, uid: String): Boolean
    fun getShipPath(tag: String, shipId: String, uid: String): ShipPathDBModel?
    fun createShipPath(
        tag: String,
        shipId: String,
        uid: String,
        landmarks: List<Vector2>,
        startTime: LocalDateTime,
        duration: Duration
    )

    fun deleteShipEntry(tag: String, shipId: String, uid: String)

    fun getShipStaticPosition(tag: String, shipId: String, uid: String): Vector2?
    fun createShipStaticPosition(
        tag: String,
        shipId: String,
        uid: String,
        staticPosition: Vector2
    )
    fun checkShipPathExists(
        tag: String,
        shipId: String,
        uid: String,
    ): Boolean
}