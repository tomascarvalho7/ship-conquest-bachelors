package com.example.shipconquest.domain.ship_navigation.utils

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.distanceTo
import com.example.shipconquest.domain.toPosition
import com.example.shipconquest.domain.world.islands.Island
import kotlin.math.abs
import kotlin.math.pow
import kotlin.math.sqrt

data class LineIntersection(val position: Position, val lineIndex: Int, val island: Island)
fun findIntersectionPoints(points: List<Vector2>, islands: List<Island>): LineIntersection? {
    var closestLine: LineIntersection? = null
    var closestDistance: Double? = null

    fun newClosestPoint(position: Position, index: Int, island: Island) {
        val start = points[0]
        val distance = position.distanceTo(start.toPosition())
        val closestDist = closestDistance
        if (closestDist == null || closestDist > distance) {
            closestLine = LineIntersection(
                position = position,
                lineIndex = index,
                island = island
            )
            closestDistance = distance
        }
    }

    for (island in islands) {
        for (i in 0 until points.size - 1) {
            val p1 = points[i]
            val p2 = points[i + 1]

            val distance = distanceToLineSegment(island.coordinate, p1, p2)
            if (distance <= island.radius / 1.5) {
                // Calculate the intersection points
                val dx = p2.x - p1.x
                val dy = p2.y - p1.y
                val a = dx.cube() + dy.cube()
                val b = 2 * (dx * (p1.x - island.coordinate.x) + dy * (p1.y - island.coordinate.y))
                val c = (p1.x - island.coordinate.x).cube() + (p1.y - island.coordinate.y).cube() - island.radius.cube()
                val discriminant = b.cube() - 4 * a * c

                if (discriminant >= 0) {
                    val t1 = (-b + sqrt(discriminant.toDouble())) / (2 * a)
                    val t2 = (-b - sqrt(discriminant.toDouble())) / (2 * a)
                    val x1 = p1.x + t1 * dx
                    val y1 = p1.y + t1 * dy
                    val x2 = p1.x + t2 * dx
                    val y2 = p1.y + t2 * dy

                    // Check if the intersection points are within the line segment
                    if (t1 in 0.0..1.0) {
                        newClosestPoint(Position(x1, y1), i, island)
                    }
                    if (t2 in 0.0..1.0) {
                        newClosestPoint(Position(x2, y2), i, island)
                    }
                }
            }
        }
    }
    return closestLine
}

fun Int.cube() = this * this
fun Int.cubeSquared() = sqrt(this * this.toDouble()).toInt()

fun distanceToLineSegment(p: Vector2, lineStart: Vector2, lineEnd: Vector2): Double {
    val dx = lineEnd.x - lineStart.x
    val dy = lineEnd.y - lineStart.y

    // the line segment is actually a point
    if (dx == 0 && dy == 0) return p.distanceTo(lineStart)

    val t = ((p.x - lineStart.x) * dx + (p.y - lineStart.y) * dy) / (dx.cube() + dy.cube())

    if (t < 0) { // closest point is beyond lineStart
        return p.distanceTo(lineStart)
    } else if (t > 1) { // closest point is beyond lineEnd
        return p.distanceTo(lineEnd)
    }

    // closest point on the line segment
    val closest = Vector2(x = lineStart.x + t * dx, y = lineStart.y + t * dy)

    return p.distanceTo(closest)
}