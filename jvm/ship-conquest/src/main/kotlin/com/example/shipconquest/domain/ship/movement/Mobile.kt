package com.example.shipconquest.domain.ship.movement

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.bezier.CubicBezier
import com.example.shipconquest.domain.bezier.utils.split
import com.example.shipconquest.domain.bezier.utils.toVector2List
import com.example.shipconquest.domain.space.toPosition
import com.example.shipconquest.domain.toVector2
import java.time.Duration
import java.time.Instant

class Mobile(
    val landmarks: List<CubicBezier>,
    val startTime: Instant,
    val duration: Duration
): Movement {
    private val endTime: Instant = startTime + duration

    fun getPoints() = landmarks.toVector2List()

    fun getUniquePoints() = landmarks.toVector2List().distinct()

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

    fun getU(instant: Instant) = getTimePercentage(now = instant, startTime, endTime) * landmarks.size

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

    fun splitPathBeforeTime(timeToCut: Instant): List<CubicBezier> {
        val bezierList= mutableListOf<CubicBezier>()
        // get u of cut instant
        val cutU = getU(timeToCut)
        //bound U by the number of landmarks
        val boundedU = if(cutU >= landmarks.size) landmarks.size.toDouble() else cutU
        val bezierIndex = boundedU.toInt()
        // find the t for the desired instant in the right bezier
        val t = boundedU - bezierIndex

        for (i in 0 until bezierIndex) {
            bezierList.addAll(listOf(landmarks[i]))
        }

        if(t > 0) bezierList.add(landmarks[bezierIndex].split(0.0, t))

        return bezierList
    }

    fun getEndTime() = endTime

    fun getFinalCoord() = getPosition(landmarks.size * 1.0).toVector2()
}