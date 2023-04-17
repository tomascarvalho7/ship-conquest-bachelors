package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Coord2D
import com.example.shipconquest.domain.ship_navigation.CubicBezier

data class CubicBezierDBModel(val p0: Coord2D, val p1: Coord2D, val p2: Coord2D, val p3: Coord2D)

fun Array<CubicBezierDBModel>.toCubicBezierList() =
    this.map {
        CubicBezier(it.p0, it.p1, it.p2, it.p3)
    }

fun List<CubicBezier>.toCubicBezierDBModelList() =
    this.map {
        CubicBezierDBModel(it.p0, it.p1, it.p2, it.p3)
    }

fun CubicBezier.toCubicBezierDBModel() =
    CubicBezierDBModel(p0, p1, p2, p3)