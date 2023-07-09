package pt.isel.shipconquest.domain.event.logic.utils

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.distanceTo
import com.example.shipconquest.domain.space.distanceTo


fun comparePoints(points: List<Position>, otherPoints: List<Position>): Double {
    if (points.isEmpty()) return 0.0
    var closestIndex = 0
    var score = Double.MAX_VALUE
    for ((index, point) in points.withIndex()) {
        for((otherIndex, otherPoint) in otherPoints.withIndex()) {
            val currentDistance = point.distanceTo(otherPoint)
            val curTimeDiff = (index - otherIndex).cubeSquared()
            val currentScore = currentDistance + curTimeDiff / 2
            if (score > currentScore) {
                score = currentScore
                closestIndex = index
            }
        }
    }

    return closestIndex / (points.size * 1.0)
}