package pt.isel.shipconquest.domain.event.logic.utils

import pt.isel.shipconquest.domain.Position
import pt.isel.shipconquest.domain.space.Vector2
import pt.isel.shipconquest.domain.world.islands.Island


data class LineIntersection(val position: Position, val lineIndex: Int, val island: Island)

fun findIntersectionPoints(points: List<Vector2>, islands: List<Island>): LineIntersection? {
    for (island in islands) {
        for (i in 0 until points.size - 1) {
            val p1 = points[i]
            val p2 = points[i + 1]

            val closestPoint = distanceToLineSegment(island.coordinate, p1, p2)
            if (closestPoint.distance <= island.radius / 1.5) {
                return LineIntersection(
                    position = closestPoint.position,
                    lineIndex = i,
                    island = island
                )
            }
        }
    }
    return null
}