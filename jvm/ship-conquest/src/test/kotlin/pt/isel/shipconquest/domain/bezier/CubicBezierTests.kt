package pt.isel.shipconquest.domain.bezier

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import pt.isel.shipconquest.domain.Position
import pt.isel.shipconquest.domain.bezier.utils.sample
import pt.isel.shipconquest.domain.bezier.utils.split
import pt.isel.shipconquest.domain.space.Vector2
import pt.isel.shipconquest.domain.space.toPosition
import pt.isel.shipconquest.domain.toVector2

class CubicBezierTests {
    @Test
    fun `get control points from cubic Bezier curve`() {
        // Define the control points
        val p0 = Vector2(x = 0, y = 0)
        val p1 = Vector2(x = 1, y = 2)
        val p2 = Vector2(x = 3, y = 4)
        val p3 = Vector2(x = 5, y = 6)

        // Create an instance of CubicBezier
        val cubicBezier = CubicBezier(p0, p1, p2, p3)

        // Check starting and end positions are the same
        val position1 = cubicBezier.get(0.0)
        assertEquals(p0.toPosition(), position1)

        val position2 = cubicBezier.get(1.0)
        assertEquals(p3.toPosition(), position2)
    }

    @Test
    fun `get intermediate points from cubic Bezier curve`() {
        // Define the control points
        val p0 = Vector2(x = 0, y = 0)
        val p1 = Vector2(x = 1, y = 2)
        val p2 = Vector2(x = 3, y = 4)
        val p3 = Vector2(x = 5, y = 6)

        // Create an instance of CubicBezier
        val cubicBezier = CubicBezier(p0, p1, p2, p3)

        // Check middle intermediate point
        val position = cubicBezier.get(0.5)
        assertEquals(Position(2.125, 3.0), position)
    }

    @Test
    fun `get out of bounds points from cubic Bezier curve`() {
        // Define the control points
        val p0 = Vector2(x = 0, y = 0)
        val p1 = Vector2(x = 1, y = 2)
        val p2 = Vector2(x = 3, y = 4)
        val p3 = Vector2(x = 5, y = 6)

        // Create an instance of CubicBezier
        val cubicBezier = CubicBezier(p0, p1, p2, p3)

        // Check starting and end positions are returned when out of bounds
        val position1 = cubicBezier.get(-0.5)
        assertEquals(p0.toPosition(), position1)

        val position2 = cubicBezier.get(3.0)
        assertEquals(p3.toPosition(), position2)
    }

    @Test
    fun `get always the same point from a Cubic Bezier made of only one point`() {
        // Define the control points
        val p0 = Vector2(x = 0, y = 0)
        val p1 = Vector2(x = 0, y = 0)
        val p2 = Vector2(x = 0, y = 0)
        val p3 = Vector2(x = 0, y = 0)

        // Create an instance of CubicBezier
        val cubicBezier = CubicBezier(p0, p1, p2, p3)

        // Check that all intermediate points are equal to Position(x = 0, y = 0)
        val position1 = cubicBezier.get(0.0)
        assertEquals(p0.toPosition(), position1)

        val position2 = cubicBezier.get(0.25)
        assertEquals(p3.toPosition(), position2)

        val position3= cubicBezier.get(0.5)
        assertEquals(p3.toPosition(), position3)

        val position4 = cubicBezier.get(0.75)
        assertEquals(p3.toPosition(), position4)

        val position5 = cubicBezier.get(1.0)
        assertEquals(p3.toPosition(), position5)
    }

    // utility
    @Test
    fun `sampling Bezier Curve by four points is redundant`() {
        // Define the control points
        val p0 = Vector2(x = 0, y = 0)
        val p1 = Vector2(x = 1, y = 2)
        val p2 = Vector2(x = 3, y = 4)
        val p3 = Vector2(x = 5, y = 6)

        // Create an instance of CubicBezier
        val cubicBezier = CubicBezier(p0, p1, p2, p3)
        val points = cubicBezier.sample(4)

        // check length
        assertEquals(4, points.size)

        // Check that all points remain the same
        assertEquals(p0, points[0].toVector2())
        assertEquals(p1, points[1].toVector2())
        assertEquals(p2, points[2].toVector2())
        assertEquals(p3, points[3].toVector2())
    }

    @Test
    fun `sampling Bezier Curve by odd numbers returns middle point`() {
        // Define the control points
        val p0 = Vector2(x = 0, y = 0)
        val p1 = Vector2(x = 1, y = 2)
        val p2 = Vector2(x = 2, y = 4)
        val p3 = Vector2(x = 4, y = 6)

        // Create an instance of CubicBezier
        val cubicBezier = CubicBezier(p0, p1, p2, p3)
        val points = cubicBezier.sample(5) // odd number

        // check length
        assertEquals(5, points.size)

        // Check that start and end points remain the same
        assertEquals(p0, points[0].toVector2())
        assertEquals(p3, points[4].toVector2())

        // Check that middle element of [points] is equal to the middle
        // of the [BezierCurve]
        assertEquals(cubicBezier.get(0.5), points[2])
    }

    @Test
    fun `split CubicBezier in half`() {
        // Define the control points
        val p0 = Vector2(x = 0, y = 0)
        val p1 = Vector2(x = 1, y = 2)
        val p2 = Vector2(x = 2, y = 4)
        val p3 = Vector2(x = 4, y = 6)

        // Create a CubicBezier instance
        val cubicBezier = CubicBezier(p0, p1, p2, p3)

        // Test splitting the curve
        val start = 0.0
        val end = 0.5
        val splitBezier = cubicBezier.split(start, end)

        // Verify the control points of the split segment
        assertEquals(cubicBezier.get(start).toVector2(), splitBezier.p0)
        assertEquals(cubicBezier.get(end).toVector2(), splitBezier.p3)
    }

    @Test
    fun `split CubicBezier in quarter`() {
        // Define the control points
        val p0 = Vector2(x = 0, y = 0)
        val p1 = Vector2(x = 1, y = 2)
        val p2 = Vector2(x = 2, y = 4)
        val p3 = Vector2(x = 4, y = 6)

        // Create a CubicBezier instance
        val cubicBezier = CubicBezier(p0, p1, p2, p3)

        // Test splitting the curve
        val start = 0.0
        val end = 0.25
        val splitBezier = cubicBezier.split(start, end)

        // Verify the control points of the split segment
        assertEquals(cubicBezier.get(start).toVector2(), splitBezier.p0)
        assertEquals(cubicBezier.get(end).toVector2(), splitBezier.p3)
    }

    @Test
    fun `CubicBezier redundant split`() {
        // Define the control points
        val p0 = Vector2(x = 0, y = 0)
        val p1 = Vector2(x = 1, y = 2)
        val p2 = Vector2(x = 2, y = 4)
        val p3 = Vector2(x = 4, y = 6)

        // Create a CubicBezier instance
        val cubicBezier = CubicBezier(p0, p1, p2, p3)

        // Test splitting the curve
        val start = 0.0
        val end = 1.0
        val splitBezier = cubicBezier.split(start, end)

        // Verify the control points of the split segment
        assertEquals(cubicBezier.p0, splitBezier.p0)
        assertEquals(cubicBezier.p1, splitBezier.p1)
        assertEquals(cubicBezier.p2, splitBezier.p2)
        assertEquals(cubicBezier.p3, splitBezier.p3)
    }
}