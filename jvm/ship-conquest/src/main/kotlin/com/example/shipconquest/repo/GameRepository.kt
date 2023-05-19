package com.example.shipconquest.repo

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.game.Game
import org.slf4j.Logger

interface GameRepository {
    val logger: Logger
    fun get(tag: String): Game?
    fun getVisitedPoints(tag: String, uid: String): List<Vector2>?
    fun createGame(game: Game)
    fun addVisitedPoint(tag: String, uid: String, point: Vector2)
    fun createVisitedPoint(tag: String, uid: String, point: Vector2)
    fun checkVisitedPointsExist(tag: String, uid: String): Boolean
}