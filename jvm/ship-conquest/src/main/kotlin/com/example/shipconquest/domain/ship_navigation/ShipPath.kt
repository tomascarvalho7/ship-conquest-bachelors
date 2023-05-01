package com.example.shipconquest.domain.ship_navigation

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.toPosition
import java.time.Duration
import java.time.Instant

class ShipPath(
    val landmarks: List<CubicBezier>,
    val startTime: Instant,
    val duration: Duration
) {
    val endTime: Instant = startTime + duration

    fun getPosition(u: Double): Position {
        val index = u.toInt()
        if (index >= landmarks.size) return landmarks.last().p3.toPosition()

        val n = u % 1
        return landmarks[index].get(n)
    }

    fun getPositionFromTime(): Position {
        val percentage = getTimePercentage(startTime, endTime)
        return getPosition(percentage * landmarks.size)
    }

    fun getCurrentDuration(): Duration = Duration.between(endTime, Instant.now())

    private fun getTimePercentage(startTime: Instant, endTime: Instant): Double {
        val now = Instant.now()
        val totalDuration = Duration.between(startTime, endTime).toMillis()
        val elapsedDuration = Duration.between(startTime, now).toMillis()
        return elapsedDuration.toDouble() / totalDuration.toDouble()
    }
}