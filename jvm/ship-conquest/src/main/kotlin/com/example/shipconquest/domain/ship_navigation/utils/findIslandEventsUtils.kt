package com.example.shipconquest.domain.ship_navigation.utils

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.distanceTo
import com.example.shipconquest.domain.toPosition
import com.example.shipconquest.domain.world.islands.Island
import kotlin.math.abs
import kotlin.math.pow
import kotlin.math.sqrt

data class LineIntersection(val position: Position, val lineIndex: Int, val islandId: Int)
fun findIntersectionPoints(points: List<Vector2>, islands: List<Island>): LineIntersection? {
    var closestLine: LineIntersection? = null
    var closestDistance: Double? = null

    fun newClosestPoint(position: Position, index: Int, islandId: Int) {
        val start = points[0]
        val distance = position.distanceTo(start.toPosition())
        val closestDist = closestDistance
        if (closestDist == null || closestDist > distance) {
            closestLine = LineIntersection(
                position = position,
                lineIndex = index,
                islandId = islandId
            )
            closestDistance = distance
        }
    }

    for (island in islands) {
        for (i in 0 until points.size - 1) {
            val p1 = points[i]
            val p2 = points[i + 1]

            val distance = distanceBetweenPointAndLine(island.coordinate, p1, p2)
            if (distance <= island.radius) {
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
                        newClosestPoint(Position(x1, y1), i, island.islandId)
                    }
                    if (t2 in 0.0..1.0) {
                        newClosestPoint(Position(x2, y2), i, island.islandId)
                    }
                }
            }
        }
    }
    return closestLine
}

fun Int.cube() = this * this
fun Int.cubeSquared() = sqrt(this * this.toDouble()).toInt()

fun distanceBetweenPointAndLine(point: Vector2, lineStart: Vector2, lineEnd: Vector2) =
    abs((lineEnd.y - lineStart.y) * point.x - (lineEnd.x - lineStart.x) * point.y
    + lineEnd.x * lineStart.y - lineEnd.y * lineStart.x) /
    sqrt((lineEnd.y - lineStart.y).toDouble().pow(2.0)
    + (lineEnd.x - lineStart.x).toDouble().pow(2.0))