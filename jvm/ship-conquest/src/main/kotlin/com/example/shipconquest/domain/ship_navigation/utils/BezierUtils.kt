package com.example.shipconquest.domain.ship_navigation.utils

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.ship_navigation.CubicBezier
import com.example.shipconquest.domain.toVector2

fun CubicBezier.sample(numPoints: Int): List<Position> {
    val stepSize = 1.0 / (numPoints - 1)
    return (0 until numPoints).map { i -> get(i * stepSize) }
}

fun CubicBezier.split(start: Double, end: Double): CubicBezier {
    val segmentLength = end - start
    val t1 = start + segmentLength / 3
    val t2 = start + (2 * (segmentLength / 3))

    return CubicBezier(
        get(start).toVector2(),
        get(t1).toVector2(),
        get(t2).toVector2(),
        get(end).toVector2(),
    )
}

fun List<CubicBezier>.toVector2List() = flatMap {
    listOf(it.p0, it.p1, it.p2, it.p3)
}