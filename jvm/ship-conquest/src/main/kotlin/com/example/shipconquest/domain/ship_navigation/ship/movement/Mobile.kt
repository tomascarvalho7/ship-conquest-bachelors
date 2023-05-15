package com.example.shipconquest.domain.ship_navigation.ship.movement

import com.example.shipconquest.controller.model.output.toVector2OutputModel
import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.ship_navigation.CubicBezier
import com.example.shipconquest.domain.toPosition
import java.time.Duration
import java.time.Instant

class Mobile(
    val landmarks: List<CubicBezier>,
    val startTime: Instant,
    val duration: Duration
): Movement {
    private val endTime: Instant = startTime + duration

    fun getPoints() = landmarks.flatMap { cubic ->
        listOf(
            cubic.p0,
            cubic.p1,
            cubic.p2,
            cubic.p3
        )
    }

    fun getUniquePoints() = landmarks.flatMap { cubic ->
        listOf(
            cubic.p0,
            cubic.p1,
            cubic.p2,
            cubic.p3
        )
    }.distinct()

    fun getPositionFromInstant(instant: Instant): Position {
        val percentage = getTimePercentage(now = instant, startTime, endTime)
        return getPosition(percentage * landmarks.size)
    }

    fun getPosition(u: Double): Position {
        val index = u.toInt()
        if (index >= landmarks.size) return landmarks.last().p3.toPosition()

        val n = u % 1
        return landmarks[index].get(n)
    }

    fun getPositionFromTime(): Position {
        val percentage = getTimePercentage(now = Instant.now(), startTime, endTime)
        return getPosition(percentage)
    }

    fun getU(instant: Instant) = getTimePercentage(now = Instant.now(), startTime, endTime) * landmarks.size

    fun getCurrentDuration(): Duration = Duration.between(endTime, Instant.now())

    private fun getTimePercentage(now: Instant, startTime: Instant, endTime: Instant): Double {
        val totalDuration = Duration.between(startTime, endTime).toMillis()
        val elapsedDuration = Duration.between(startTime, now).toMillis()
        return elapsedDuration.toDouble() / totalDuration.toDouble()
    }

    fun getInstant(u: Double): Instant {
        val percentage = u / landmarks.size.toDouble()
        val totalDuration = Duration.between(startTime, endTime).toMillis()
        val elapsedDuration = (totalDuration * percentage).toLong()
        return startTime.plusMillis(elapsedDuration)
    }
}