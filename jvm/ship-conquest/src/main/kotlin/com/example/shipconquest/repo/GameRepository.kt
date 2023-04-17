package com.example.shipconquest.repo

import com.example.shipconquest.domain.Game
import com.example.shipconquest.domain.Coord2D
import com.example.shipconquest.domain.ship_navigation.CubicBezier
import com.example.shipconquest.domain.ship_navigation.ShipPath
import com.example.shipconquest.repo.jdbi.dbmodel.ShipPathDBModel
import org.slf4j.Logger
import java.time.Duration
import java.time.LocalDateTime

interface GameRepository {
    val logger: Logger
    fun get(tag: String): Game?
    fun getVisitedPoints(tag: String, uid: String): List<Coord2D>?
    fun createGame(game: Game)
    fun addVisitedPoint(tag: String, uid: String, point: Coord2D)
    fun createVisitedPoint(tag: String, uid: String, point: Coord2D)
    fun checkVisitedPointsExist(tag: String, uid: String): Boolean
    fun getShipPath(tag: String, shipId: String, uid: String): ShipPath?
    fun createShipPath(
        tag: String,
        shipId: String,
        uid: String,
        landmarks: List<CubicBezier>,
        startTime: LocalDateTime,
        duration: Duration
    )
    fun deleteShipPath(tag: String, shipId: String, uid: String)
}