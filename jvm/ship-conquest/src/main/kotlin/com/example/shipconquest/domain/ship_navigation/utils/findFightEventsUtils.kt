package com.example.shipconquest.domain.ship_navigation.utils

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.distanceTo


fun comparePoints(points: List<Position>, otherPoints: List<Position>): Int {
    var closestIndex = 0
    var score = Double.MAX_VALUE
    for ((index, point) in points.withIndex()) {
        for((otherIndex, otherPoint) in otherPoints.withIndex()) {
            val currentDistance = point.distanceTo(otherPoint)
            val curTimeDiff = (index - otherIndex).cubeSquared()
            val currentScore = currentDistance + curTimeDiff / 2
            if (score > currentScore) {
                closestIndex = index
            }
        }
    }

    return closestIndex
}