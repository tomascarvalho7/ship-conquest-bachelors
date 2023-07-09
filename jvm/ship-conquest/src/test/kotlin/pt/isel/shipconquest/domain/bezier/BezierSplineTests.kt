package pt.isel.shipconquest.domain.bezier

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.space.toPosition
import com.example.shipconquest.domain.toVector2
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotEquals
import org.junit.jupiter.api.Test

class BezierSplineTests {
    private val cubicBezierA = CubicBezier(
        p0 = Vector2(x = 0, y = 0), p1 = Vector2(x = 2, y = 2),
        p2 = Vector2(x = 4, y = 2), p3 = Vector2(x = 6, y = 4)
    )
    private val cubicBezierB = CubicBezier(
        p0 = Vector2(x = 6, y = 4), p1 = Vector2(x = 6, y = 6),
        p2 = Vector2(x = 6, y = 8), p3 = Vector2(x = 8, y = 10)
    )
    private val exampleSpline = BezierSpline(
        segments = listOf(cubicBezierA, cubicBezierB)
    )

    @Test
    fun `get spline starting position`() {
        val u = 0.0
        val expected = cubicBezierA.p0.toPosition()
        // assert starting position is equal to interpolation value 0
        assertEquals(expected, exampleSpline.getPosition(u = u))
    }

    @Test
    fun `get spline middle position`() {
        // get the interpolation value for the middle of the spline
        val u = exampleSpline.segments.size / 2.0
        // middle points
        val expectedA = cubicBezierA.p3.toPosition()
        val expectedB = cubicBezierB.p0.toPosition()
        // assert starting position is equal to interpolation value 1.0
        val result = exampleSpline.getPosition(u = u)
        assertEquals(1.0, u)
        assertEquals(expectedA, result)
        assertEquals(expectedB, result)
    }

    @Test
    fun `get spline end position`() {
        // get the interpolation value for the end of the spline
        val u = exampleSpline.segments.size * 1.0
        // end point
        val expected = cubicBezierB.p3.toPosition()
        // assert starting position is equal to interpolation value 2.0
        assertEquals(2.0, u)
        assertEquals(expected, exampleSpline.getPosition(u = u))
    }

    @Test
    fun `get spline out of bounds position with negative interpolation value`() {
        // negative interpolation value
        val u = - 2.0
        // start point
        val expected = cubicBezierA.p0.toPosition()
        // assert expected position is equal to start position because u is clamped
        assertEquals(expected, exampleSpline.getPosition(u = u))
    }

    @Test
    fun `get spline out of bounds position with out of range interpolation value`() {
        // negative interpolation value
        val u = 45.0
        // start point
        val expected = cubicBezierB.p3.toPosition()
        // assert expected position is equal to start position because u is clamped
        assertEquals(expected, exampleSpline.getPosition(u = u))
    }

    @Test
    fun `splitting spline in half is equal to just having a cubicBezier`() {
        // get the interpolation value for the middle of the spline
        val start = 0.0
        val end = exampleSpline.segments.size / 2.0
        val splitSpline = exampleSpline.split(u = end)
        // assert split spline is correct
        assertEquals(exampleSpline.getPosition(start), splitSpline.getPosition(start))
        assertEquals(exampleSpline.getPosition(end), splitSpline.segments[0].p3.toPosition())
        // assert split spline is equal to only one [CubicBezier]
        assertEquals(1, splitSpline.segments.size)
        assertEquals(cubicBezierA.get(0.25), splitSpline.getPosition(0.25))
        assertEquals(cubicBezierA.get(0.5), splitSpline.getPosition(0.5))
        assertEquals(cubicBezierA.get(0.75), splitSpline.getPosition(0.75))
    }

    @Test
    fun `split spline in quarter`() {
        // get the interpolation value for the middle of the spline
        val start = 0.0
        val end = exampleSpline.segments.size / 4.0
        val splitSpline = exampleSpline.split(u = end)
        // assert split spline is correct
        assertEquals(1, splitSpline.segments.size)
        assertEquals(exampleSpline.getPosition(start), splitSpline.getPosition(start))
        assertEquals(exampleSpline.getPosition(end).toVector2(), splitSpline.segments[0].p3)
    }

    @Test
    fun `redundant spline split`() {
        // get the interpolation value for the middle of the spline
        val start = 0.0
        val end = exampleSpline.segments.size * 1.0
        val splitSpline = exampleSpline.split(u = end)
        // assert split spline is correct
        assertEquals(2, splitSpline.segments.size)
        assertEquals(exampleSpline.getPosition(start), splitSpline.getPosition(start))
        assertEquals(exampleSpline.getPosition(end), splitSpline.getPosition(end))
    }
}