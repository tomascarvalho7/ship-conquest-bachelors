package com.example.shipconquest.domain.bezier.utils

import com.example.shipconquest.domain.bezier.BezierSpline
import com.example.shipconquest.domain.bezier.CubicBezier
import com.example.shipconquest.domain.space.Vector2

fun buildSpline(points: List<Vector2>): BezierSpline? {
    if (points.size % 4 != 0) return null

    return BezierSpline(segments = List(points.size / 4) { index ->
        CubicBezier(
            p0 = points[index * 4],
            p1 = points[(index * 4) + 1],
            p2 = points[(index * 4) + 2],
            p3 = points[(index * 4) + 3]
        )
    })
}