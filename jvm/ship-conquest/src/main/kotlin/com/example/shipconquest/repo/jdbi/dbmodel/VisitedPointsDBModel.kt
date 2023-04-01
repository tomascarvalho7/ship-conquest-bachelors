package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.VisitedPoints

data class VisitedPointsDBModel(val gameTag: String, val uid: String, val points: List<PositionDBModel>)

fun VisitedPointsDBModel.toVisitedPoints() =
    VisitedPoints(gameTag, uid, points = points.map { point -> Position(point.x, point.y) })