package com.example.shipconquest.domain.movement

import com.example.shipconquest.ClockStub
import com.example.shipconquest.domain.bezier.BezierSpline
import com.example.shipconquest.domain.bezier.CubicBezier
import com.example.shipconquest.domain.ship.movement.Kinetic
import com.example.shipconquest.domain.space.Vector2
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotEquals
import org.junit.jupiter.api.Test
import java.time.Duration

class KineticTests {
    private val clock = ClockStub()
    private val start = clock.now()
    private val duration = Duration.ofMinutes(30)
    private val startPoint = Vector2(1, 0)
    private val endPoint = Vector2(10, 10)
    private val exampleMovement = Kinetic(
        spline = BezierSpline(
            segments = listOf(
                CubicBezier(Vector2(1, 0), Vector2(4, 0), Vector2(7, 0), Vector2(10, 0)),
                CubicBezier(Vector2(10, 0), Vector2(10, 4), Vector2(10, 7), Vector2(10, 10))
            )
        ),
        startTime = start,
        duration = duration
    )

    @Test
    fun `check expected end instant from movement`() {
        val endTime = start + duration
        // Test successful case
        assertEquals(endTime, exampleMovement.endTime)
    }
    @Test
    fun `get expected coordinate from start instant`() {
        // Test successful case
        assertEquals(start, exampleMovement.startTime)
        assertEquals(startPoint, exampleMovement.getCoordinateFromInstant(start))
    }

    @Test
    fun `get expected coordinate from end instant`() {
        // Test successful case
        val endTime = start + duration
        assertEquals(endTime, exampleMovement.endTime)
        assertEquals(endPoint, exampleMovement.getCoordinateFromInstant(endTime))
    }

    @Test
    fun `get expected interpolation value from end instant`() {
        // expected interpolation value should be equal to segments size
        val u = exampleMovement.spline.segments.size * 1.0
        val endTime = start + duration
        // Test successful case
        assertEquals(endTime, exampleMovement.endTime)
        assertEquals(u, exampleMovement.getU(endTime))
    }

    @Test
    fun `get expected coordinate at the middle of the movement`() {
        // get the instant the movement is half complete
        val instant = start + duration.dividedBy(2)
        // The kinetic spline contains duplicate points at the [CubicBezier] intersecting points
        // thus for a spline with length = 2, the middle point will be the intersecting point of the
        // two [CubicBezier]'s
        assertEquals(Vector2(x = 10, y = 0), exampleMovement.getCoordinateFromInstant(instant))
    }

    @Test
    fun `get expected coordinate from invalid instant before start time`() {
        // Test unsuccessful case
        val invalidInstant = start - duration
        assertNotEquals(invalidInstant, exampleMovement.startTime)
        // value is clamped so an instant out of bounds will either be equal to a start or end point
        assertEquals(startPoint, exampleMovement.getCoordinateFromInstant(invalidInstant))
    }

    // get control points tests

    @Test
    fun `get expected points from getPoints method`() {
        val expectedControlPoints = listOf(
            Vector2(1, 0), Vector2(4, 0), Vector2(7, 0), Vector2(10, 0),
            Vector2(10, 0), Vector2(10, 4), Vector2(10, 7), Vector2(10, 10)
        )
        // assert
        val points = exampleMovement.getPoints()
        assertEquals(8, points.size)
        assertEquals(expectedControlPoints, points)
    }

    @Test
    fun `fail getting unique points from getPoints method`() {
        val expectedControlPoints = listOf(
            Vector2(1, 0), Vector2(4, 0), Vector2(7, 0), Vector2(10, 0),
            Vector2(10, 4), Vector2(10, 7), Vector2(10, 10)
        )
        // assert
        val points = exampleMovement.getPoints()
        assertNotEquals(7, points.size)
        assertNotEquals(expectedControlPoints, points)
    }

    @Test
    fun `get expected unique points from getUniquePoints method`() {
        val expectedControlPoints = listOf(
            Vector2(1, 0), Vector2(4, 0), Vector2(7, 0), Vector2(10, 0),
            Vector2(10, 4), Vector2(10, 7), Vector2(10, 10)
        )
        // assert
        val points = exampleMovement.getUniquePoints()
        assertEquals(7, points.size)
        assertEquals(expectedControlPoints, points)
    }

    // get interpolation value tests

    @Test
    fun `get expected interpolation value from start instant`() {
        // expected interpolation value should be equal to 0
        val u = 0.0
        // Test successful case
        assertEquals(start, exampleMovement.startTime)
        assertEquals(u, exampleMovement.getU(start))
    }

    @Test
    fun `get expected interpolation value at the middle of the movement`() {
        val u = exampleMovement.spline.segments.size * 0.5
        // get the instant the movement is half complete
        val instant = start + duration.dividedBy(2)
        assertEquals(u, exampleMovement.getU(instant))
    }

    @Test
    fun `get expected interpolation value from invalid instant before start time`() {
        // expected result
        val u = 0.0
        val invalidInstant = start - duration
        // Test unsuccessful case
        assertNotEquals(invalidInstant, exampleMovement.startTime)
        // value is clamped so an instant out of bounds will either be equal to a start or end u
        assertEquals(u, exampleMovement.getU(invalidInstant))
    }

    @Test
    fun `get expected interpolation value from invalid instant after end time`() {
        // expected result
        val u = exampleMovement.spline.segments.size * 1.0
        val invalidInstant = start + duration + duration
        // Test unsuccessful case
        assertNotEquals(invalidInstant, exampleMovement.startTime)
        // value is clamped so an instant out of bounds will either be equal to a start or end u
        assertEquals(u, exampleMovement.getU(invalidInstant))
    }

    @Test
    fun `get expected coordinate from invalid instant after end time`() {
        // Test unsuccessful case
        val invalidInstant = start + duration + duration
        assertNotEquals(invalidInstant, exampleMovement.endTime)
        // value is clamped so an instant out of bounds will either be equal to a start or end point
        assertEquals(endPoint, exampleMovement.getCoordinateFromInstant(invalidInstant))
    }

    // shorten tests
    @Test
    fun `get the same movement after redundant shorten`() {
        val endInstant = exampleMovement.endTime
        val sameMovement = exampleMovement.shorten(endInstant)
        // assert
        assertEquals(exampleMovement.getPoints(), sameMovement.getPoints())
        assertEquals(exampleMovement.startTime, sameMovement.startTime)
        assertEquals(exampleMovement.duration, sameMovement.duration)
    }

    @Test
    fun `slice movement in half`() {
        // get the instant the movement is half complete
        val instant = start + duration.dividedBy(2)
        val newMovement = exampleMovement.shorten(instant)
        // assert
        assertEquals(exampleMovement.startTime, newMovement.startTime) // start time stays the same
        assertEquals(exampleMovement.getPoints().take(4), newMovement.getPoints())
        assertNotEquals(exampleMovement.getPoints(), newMovement.getPoints()) // control points are not the same anymore
        assertEquals(exampleMovement.duration, newMovement.duration.multipliedBy(2)) //
    }
}