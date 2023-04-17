package com.example.shipconquest.domain.ship_navigation

import com.example.shipconquest.domain.Coord2D
import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.toPosition
import kotlin.math.atan2
import kotlin.math.pow
import kotlin.math.sqrt

class CubicBezier(val p0: Coord2D, val p1: Coord2D, val p2: Coord2D, val p3: Coord2D) {

    fun get(n: Double): Position {
        val _n = 1.0 - n
        val _n2 = _n.pow(2)
        val _n3 = _n2 * _n
        val n2 = n.pow(2)
        val n3 = n2 * n
        // formula:
        // P(t) = (1 - t)^3 * P1 + 3 * (1 - t)^2 * t * P2 + 3 * (1 - t) * t^2 * P3 + t^3 * P4
        return Position(
            x = _n3 * p0.x + 3 * _n2 * n * p1.x + 3 * _n * n2 * p2.x + n3 * p3.x,
            y = _n3 * p0.y + 3 * _n2 * n * p1.y + 3 * _n * n2 * p2.y + n3 * p3.y
        )
    }

    fun getAngleAtPoint(n: Double): Double {
        val tangent: Position = getTangentAtPoint(n)
        var angle = atan2(tangent.y, tangent.x)
        // convert negative angle to positive equivalent
        if (angle < 0) angle += 2 * Math.PI
        return angle * 180 / Math.PI // convert to degrees
    }

    fun getTangentAtPoint(n: Double): Position {
        val dp0: Position = (p1 - p0).toPosition() * 3.0
        val dp1 = (p2 - p1).toPosition() * 3.0
        val dp2 = (p3 - p2).toPosition() * 3.0

        val _n = 1.0 - n
        val _n2 = _n.pow(2)
        val n2 = n.pow(2)
        // get tangent
        val tangent = dp0 * _n2 + dp1 * (2 * _n * n) + dp2 * n2
        // normalize
        val length = sqrt(tangent.x * tangent.x + tangent.y * tangent.y)
        return Position(x = tangent.x / length, y = tangent.y / length)
    }
}