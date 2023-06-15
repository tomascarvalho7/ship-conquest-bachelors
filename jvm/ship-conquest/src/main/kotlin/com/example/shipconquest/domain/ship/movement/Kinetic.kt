package com.example.shipconquest.domain.ship.movement

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.bezier.BezierSpline
import com.example.shipconquest.domain.bezier.utils.toVector2List
import java.time.Duration
import java.time.Instant

class Kinetic(
    val spline: BezierSpline,
    val startTime: Instant,
    val duration: Duration
): Movement {
    val endTime: Instant = startTime + duration

    fun getPoints() = spline.segments.toVector2List()

    fun getUniquePoints() = getPoints().distinct()


    fun getPositionFromInstant(instant: Instant): Position {
        val percentage = getTimePercentage(now = instant, startTime, endTime)
        return spline.getPosition(percentage * spline.segments.size)
    }

    fun getU(instant: Instant) =
        getTimePercentage(now = instant, startTime, endTime) * spline.segments.size

    fun getInstant(u: Double): Instant {
        val percentage = u / spline.segments.size.toDouble()
        val totalDuration = Duration.between(startTime, endTime).toMillis()
        val elapsedDuration = (totalDuration * percentage).toLong()
        return startTime.plusMillis(elapsedDuration)
    }

    fun shorten(instant: Instant) = Kinetic(
        spline = spline.split(u = getU(instant)),
        startTime = startTime,
        duration = Duration.between(startTime, instant)
    )

    private fun getTimePercentage(now: Instant, startTime: Instant, endTime: Instant): Double {
        val totalDuration = Duration.between(startTime, endTime).toMillis()
        val elapsedDuration = Duration.between(startTime, now).toMillis()
        return elapsedDuration.toDouble() / totalDuration.toDouble()
    }
}