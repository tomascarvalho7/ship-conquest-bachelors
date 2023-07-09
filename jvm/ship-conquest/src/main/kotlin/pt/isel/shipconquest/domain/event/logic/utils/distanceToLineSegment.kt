package pt.isel.shipconquest.domain.event.logic.utils

import pt.isel.shipconquest.domain.Position
import pt.isel.shipconquest.domain.distanceTo
import pt.isel.shipconquest.domain.space.Vector2
import pt.isel.shipconquest.domain.space.distanceTo
import pt.isel.shipconquest.domain.space.toPosition
import kotlin.math.sqrt

data class ClosestPoint(val position: Position, val distance: Double)

fun distanceToLineSegment(p: Vector2, lineStart: Vector2, lineEnd: Vector2): ClosestPoint {
    val dx = lineEnd.x - lineStart.x
    val dy = lineEnd.y - lineStart.y

    // the line segment is actually a point
    if (dx == 0 && dy == 0) return ClosestPoint(lineStart.toPosition(), p.distanceTo(lineStart))

    val t = ((p.x - lineStart.x) * dx + (p.y - lineStart.y) * dy) / (dx.cube() + dy.cube())

    if (t < 0) { // closest point is beyond lineStart
        return ClosestPoint(lineStart.toPosition(), p.distanceTo(lineStart))
    } else if (t > 1) { // closest point is beyond lineEnd
        return ClosestPoint(lineEnd.toPosition(), p.distanceTo(lineEnd))
    }

    // closest point on the line segment
    val closest = Position(x = lineStart.x + t * dx, y = lineStart.y + t * dy)

    return ClosestPoint(
        position = closest,
        distance = p.toPosition().distanceTo(closest)
    )
}

fun Int.cube() = this * this * 1.0
fun Int.cubeSquared() = sqrt(cube())