package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.bezier.CubicBezier

data class CubicBezierDBModel(val p0: Vector2, val p1: Vector2, val p2: Vector2, val p3: Vector2)

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