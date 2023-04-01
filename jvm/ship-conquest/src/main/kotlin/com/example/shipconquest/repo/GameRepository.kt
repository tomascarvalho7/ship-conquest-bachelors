package com.example.shipconquest.repo

import com.example.shipconquest.domain.Game
import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.VisitedPoints
import com.example.shipconquest.repo.jdbi.dbmodel.PositionDBModel
import org.slf4j.Logger

interface GameRepository {
    val logger: Logger
    fun get(tag: String): Game?
    fun getVisitedPoints(tag: String, uid: String): List<Position>?
    fun createGame(game: Game)
    fun addVisitedPoint(tag: String, uid: String, point: Position)

    fun createVisitedPoint(tag: String, uid: String, point: Position)
    fun checkVisitedPointsExist(tag: String, uid: String): Boolean
}