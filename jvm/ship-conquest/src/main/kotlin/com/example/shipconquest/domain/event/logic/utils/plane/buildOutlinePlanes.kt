package com.example.shipconquest.domain.event.logic.utils.plane

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.space.Vector2

fun buildOutlinePlanes(points: List<Vector2>, thickness: Double) = buildList {
    for (i in 0 until points.size - 1) {
        val previousPoint = if (i > 0) points[i - 1] else null
        val current = points[i]
        val next = points[i + 1]
        val nextPoint = if (i < points.size - 2) points[i + 2] else null

        add(
            buildPlaneFn(current, next, thickness, previousPoint, nextPoint)
        )
    }
}

private fun buildPlaneFn(a: Vector2, b: Vector2, thickness: Double, previousReference: Vector2?, nextReference: Vector2?): Plane {
    // calculate the normal vector to the line segment
    val normal = a.getNormalBetween(b).normalize()
    // get normals from reference
    val previousNormal = previousReference?.getNormalBetween(a)?.normalize() ?: Vector(0.0, 0.0)
    val nextNormal = nextReference?.getNormalBetween(b)?.normalize()?.reverse() ?: Vector(0.0, 0.0)
    // combine them
    val unitNormalA = normal.plus(previousNormal).normalize() * thickness
    val unitNormalB = normal.plus(nextNormal).normalize() * thickness

    // calculate the four points that make up the plane
    // a --- b
    // d --- c
    return Plane(
        a = Position(a.x + unitNormalA.x, a.y + unitNormalA.y),
        b = Position(b.x + unitNormalB.x, b.y + unitNormalB.y),
        c = Position(b.x - unitNormalB.x, b.y - unitNormalB.y),
        d = Position(a.x - unitNormalA.x, a.y - unitNormalA.y)
    )
}

private fun Vector2.getNormalBetween(other: Vector2): Vector {
    val dx = other.x - x
    val dy = other.y - y
    return Vector(-dy.toDouble(), dx.toDouble())
}