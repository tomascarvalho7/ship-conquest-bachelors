package com.example.shipconquest.domain.ship_navigation.ship.movement

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.event.event_details.updateMovement
import com.example.shipconquest.domain.ship_navigation.CubicBezier
import com.example.shipconquest.domain.ship_navigation.utils.split
import com.example.shipconquest.domain.toPosition
import java.time.Duration
import java.time.Instant
import kotlin.math.max
import kotlin.math.min

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

    fun getU(instant: Instant) = getTimePercentage(now = instant, startTime, endTime) * landmarks.size

    fun getCurrentDuration(): Duration = Duration.between(endTime, Instant.now())

    private fun getTimePercentage(now: Instant, startTime: Instant, endTime: Instant): Double {
        val totalDuration = Duration.between(startTime, endTime).toMillis()
        val elapsedDuration = Duration.between(startTime, now).toMillis()
        return min(elapsedDuration.toDouble() / totalDuration.toDouble(), 1.0)
    }

    fun getInstant(u: Double): Instant {
        val percentage = u / landmarks.size.toDouble()
        val totalDuration = Duration.between(startTime, endTime).toMillis()
        val elapsedDuration = (totalDuration * percentage).toLong()
        return startTime.plusMillis(elapsedDuration)
    }

    private fun getInstantFromPoint(point: Vector2): Instant? {
        for (i in landmarks.indices) {
            val cubic = landmarks[i]
            val positions = listOf(cubic.p0, cubic.p1, cubic.p2, cubic.p3)

            if (positions.contains(point)) {
                val segmentPercentage = 1.0 / positions.size
                val u = i + (positions.indexOf(point) * segmentPercentage)
                return getInstant(u)
            }
        }
        // Point not found in any segment
        return null
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
}
