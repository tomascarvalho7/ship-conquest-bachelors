package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.VisitedPoints

data class VisitedPointsDBModel(val gameTag: String, val uid: String, val points: List<PositionDBModel>)

fun VisitedPointsDBModel.toVisitedPoints() =
    VisitedPoints(gameTag, uid, points = points.map { point -> Vector2(point.x, point.y) })