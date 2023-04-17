package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Coord2D
import com.example.shipconquest.domain.VisitedPoints

data class VisitedPointsDBModel(val gameTag: String, val uid: String, val points: List<PositionDBModel>)

fun VisitedPointsDBModel.toVisitedPoints() =
    VisitedPoints(gameTag, uid, points = points.map { point -> Coord2D(point.x, point.y) })