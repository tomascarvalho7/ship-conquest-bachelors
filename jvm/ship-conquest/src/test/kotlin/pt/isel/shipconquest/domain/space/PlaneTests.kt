package pt.isel.shipconquest.domain.space

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import pt.isel.shipconquest.domain.Position
import pt.isel.shipconquest.domain.event.logic.utils.plane.Plane
import pt.isel.shipconquest.domain.event.logic.utils.plane.buildOutlinePlanes

class PlaneTests {
    @Test
    fun testPlaneCreation() {
        val a = Position(0.0, 0.0)
        val b = Position(1.0, 0.0)
        val c = Position(1.0, 1.0)
        val d = Position(0.0, 1.0)

        val plane = Plane(a, b, c, d)

        assertEquals(a, plane.a)
        assertEquals(b, plane.b)
        assertEquals(c, plane.c)
        assertEquals(d, plane.d)
    }

    @Test
    fun testBuildOutlinePlanesNormals() {
        //| -- |
        //0 -- 1
        //| -- |
        val points = listOf(
            Vector2(0, 0),
            Vector2(1, 0),
        )
        val thickness = 1.0

        val planes = buildOutlinePlanes(points, thickness)

        assertEquals(points.size - 1, planes.size)
        assertEquals(points[0].x.toDouble(), planes[0].a.x)
        assertEquals(points[0].x.toDouble(), planes[0].d.x)
        assertEquals(points[1].x.toDouble(), planes[0].c.x)
        assertEquals(points[1].x.toDouble(), planes[0].b.x)
    }

    @Test
    fun testBuildOutlinePlanesConnection() {
        //| -- | -- |
        //0 -- 1 -- 2
        //| -- | -- |
        val points = listOf(
            Vector2(0, 0),
            Vector2(1, 0),
            Vector2(2, 1),
        )
        val thickness = 1.0

        val planes = buildOutlinePlanes(points, thickness)

        assertEquals(points.size - 1, planes.size)
        // check top vertices (B and A)
        assertEquals(planes[0].b.x, planes[1].a.x)
        assertEquals(planes[0].b.y, planes[1].a.y)
        // check bottom vertices (C and D)
        assertEquals(planes[0].c.x, planes[1].d.x)
        assertEquals(planes[0].c.y, planes[1].d.y)
    }

    @Test
    fun testBuildOutlinePlanesWithSinglePoint() {
        val points = listOf(Vector2(0, 0))
        val thickness = 0.1

        val planes = buildOutlinePlanes(points, thickness)

        assertEquals(0, planes.size)
    }

    @Test
    fun testBuildOutlinePlanesWithEmptyPoints() {
        val points = emptyList<Vector2>()
        val thickness = 0.1

        val planes = buildOutlinePlanes(points, thickness)

        assertEquals(0, planes.size)
    }
}