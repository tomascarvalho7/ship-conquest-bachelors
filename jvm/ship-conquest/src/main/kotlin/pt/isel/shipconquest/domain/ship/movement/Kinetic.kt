package pt.isel.shipconquest.domain.ship.movement

import com.example.shipconquest.domain.bezier.BezierSpline
import com.example.shipconquest.domain.bezier.utils.toVector2List
import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.toVector2
import com.example.shipconquest.domain.utils.clamp
import java.time.Duration
import java.time.Instant

/**
 * The [Kinetic] class implement's the [Movement] interface, and represents
 * a non-stationary kinetic movement.
 *
 * Movement path defined by a [BezierSpline] with a given [duration] after a
 * given [startTime].
 */
class Kinetic(
    val spline: BezierSpline,
    val startTime: Instant,
    val duration: Duration
): Movement {
    val endTime: Instant = startTime + duration

    override fun getCoordinateFromInstant(instant: Instant): Vector2 {
        val percentage = getTimePercentage(now = instant, startTime, endTime)
        return spline.getPosition(percentage * spline.segments.size).toVector2()
    }

    // get spline control points
    fun getPoints() = spline.segments.toVector2List()

    // get spline unique control points
    fun getUniquePoints() = getPoints().distinct()

    // get interpolation value (U) of the spline from a given [Instant]
    fun getU(instant: Instant) = getTimePercentage(now = instant, startTime, endTime) * spline.segments.size

    // get [instant] from an interpolation value (U) of the spline
    fun getInstant(u: Double): Instant {
        val percentage = u / spline.segments.size.toDouble()
        val totalDuration = Duration.between(startTime, endTime).toMillis()
        val elapsedDuration = (totalDuration * percentage).toLong()
        return startTime.plusMillis(elapsedDuration)
    }

    // shorten the [Kinetic] movement from [startTime] to given [Instant]
    fun shorten(instant: Instant) = Kinetic(
        spline = spline.split(u = getU(instant)),
        startTime = startTime,
        duration = Duration.between(startTime, instant)
    )

    private fun getTimePercentage(now: Instant, startTime: Instant, endTime: Instant): Double {
        val totalDuration = Duration.between(startTime, endTime).toMillis()
        val elapsedDuration = Duration.between(startTime, now).toMillis()
        return (elapsedDuration.toDouble() / totalDuration.toDouble()).clamp(min = 0.0, max = 1.0)
    }
}