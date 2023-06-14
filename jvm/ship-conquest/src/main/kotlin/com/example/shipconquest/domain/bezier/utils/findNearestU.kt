package com.example.shipconquest.domain.bezier.utils

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.distanceTo
import com.example.shipconquest.domain.space.distanceTo
import com.example.shipconquest.domain.event.logic.utils.LineIntersection
import com.example.shipconquest.domain.ship.movement.Mobile
import kotlin.math.sqrt

/**
 * Find nearest interpolation point between group of [CubicBezier]'s for
 * a given point.
 */
fun findNearestU(intersection: LineIntersection, pathMovement: Mobile): Double {
    val iterations = 10
    val u = intersection.lineIndex.floorDiv(3)
    var minT = 0.0
    var maxT = 1.0
    var bestT = 0.5 // initial guess for t
    var bestDiff = Double.MAX_VALUE

    for(i in 0 until iterations) {
        val t = ((minT + maxT) / 4)
        for(n in 1 until 4) {
            val tOffset = t * n
            val distance = pathMovement.getPosition(u = u + tOffset).distanceTo(intersection.position)

            if (distance < bestDiff) {
                bestT = tOffset
                bestDiff = distance
                if (i > 1) minT += t
                if (i < 3) maxT -= t
            }
        }
    }

    return u + bestT
}

/**
 * [Position] utility functions for math formulas.
 */
fun Position.length() = sqrt(x * x + y * y)
fun Position.lengthSquared() = x * x + y * y
fun Position.dot(other: Position) = x * other.x + y * other.y