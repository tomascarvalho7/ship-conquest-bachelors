package com.example.shipconquest.domain.ship_navigation

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.toCoord2D
import com.example.shipconquest.domain.toPosition
import java.time.Duration
import java.time.LocalDateTime

class ShipPath(
    val landmarks: List<CubicBezier>,
    val startTime: LocalDateTime,
    val duration: Duration
) {
    val endTime = startTime + duration

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

    fun getCurrentDuration(): Duration = Duration.between(endTime, LocalDateTime.now())

    private fun getTimePercentage(startTime: LocalDateTime, endTime: LocalDateTime): Double {
        val now = LocalDateTime.now()
        val totalDuration = Duration.between(startTime, endTime).toMillis()
        val elapsedDuration = Duration.between(startTime, now).toMillis()
        return elapsedDuration.toDouble() / totalDuration.toDouble()
    }
}