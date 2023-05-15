package com.example.shipconquest.domain.ship_navigation.utils

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.ship_navigation.ship.movement.Mobile
import kotlin.math.sqrt

fun findNearestU(intersection: LineIntersection, pathMovement: Mobile): Double {
    val iterations = 10
    val u = intersection.lineIndex.floorDiv(3)
    var minT = 0.0
    var maxT = 1.0
    var bestT = 0.5 // initial guess for t
    var bestDiff = Double.MAX_VALUE

    for(i in 0 until iterations) {
        val t = (minT + maxT) / 2
        val diff = pathMovement.getPosition(u = u + t) - intersection.position
        val len = diff.length()

        if (len < bestDiff) {
            bestT = t
            bestDiff = len
        }

        if (diff.x > 0) minT = t else maxT = t
    }

    // TODO: Apply newton new law???

    return u + bestT
}

fun Position.length() = sqrt(x * x + y * y)
fun Position.lengthSquared() = x * x + y * y
fun Position.dot(other: Position) = x * other.x + y * other.y