package com.example.shipconquest.domain.event.logic

import com.example.shipconquest.Clock
import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.logic.utils.plane.buildOutlinePlanes
import com.example.shipconquest.domain.event.logic.utils.plane.isOverlapping
import com.example.shipconquest.domain.bezier.CubicBezier
import com.example.shipconquest.domain.ship.ShipBuilder
import com.example.shipconquest.domain.ship.getMobileMovementOrNull
import com.example.shipconquest.domain.ship.movement.Mobile
import com.example.shipconquest.domain.bezier.utils.*
import com.example.shipconquest.domain.distanceTo
import com.example.shipconquest.domain.event.logic.utils.calculateWinner
import com.example.shipconquest.domain.event.logic.utils.comparePoints
import com.example.shipconquest.domain.event.logic.utils.findIntersectionPoints
import com.example.shipconquest.domain.space.toPosition
import com.example.shipconquest.domain.world.islands.Island
import java.time.Instant
import kotlin.math.min

/**
 * The [EventLogic] class handles event-related logic, including building fight events and island events.
 */
class EventLogic(private val clock: Clock) {
    // find the first intersection between two ships to build a fight event
    fun buildFightEventsBetweenShips(
        current: ShipBuilder,
        enemy: ShipBuilder,
        onEvent: (instant: Instant, fightDetails: FightEvent) -> Event
    ): Event? {
        val movement = current.getMobileMovementOrNull(clock.now()) ?: return null
        val enemyMovement = enemy.getMobileMovementOrNull(clock.now()) ?: return null

        val instant = getFirstIntersection(movement, enemyMovement) ?: return null
        val fightDetails = FightEvent(current.info.id, enemy.info.id, calculateWinner())

        return onEvent(instant, fightDetails)
    }

    // find the first intersection between a ship and the unknown islands
    fun buildIslandEvents(
        pathMovement: Mobile,
        islands: List<Island>,
        onIslandEvent: (instant: Instant, island: Island) -> Event
    ): List<Event> {
        val intersection = findIntersectionPoints(pathMovement.getUniquePoints(), islands) ?: return emptyList()
        val points = pathMovement
            .landmarks[intersection.lineIndex / 3]
            .sample(10)


        val u = findNearestPointToIsland(points, intersection.island) + (intersection.lineIndex / 3)
        return listOf(onIslandEvent(pathMovement.getInstant(u), intersection.island))
    }

    // find the closest point to the island without intersecting it
    private fun findNearestPointToIsland(points: List<Position> , island: Island): Double {
        var bestDistance = Double.MAX_VALUE
        var t = 0.0
        for ((index, point) in points.withIndex()) {
            val distance = point.distanceTo(island.coordinate.toPosition())
            if (distance <= island.radius * 0.6) return t
            if (distance < bestDistance) {
                bestDistance = distance
                t = index / 10.0
            }
        }

        return t
    }

    // get first intersection between two ships
    private fun getFirstIntersection(movement: Mobile, enemy: Mobile): Instant? {
        val pathOutline = buildOutlinePlanes(movement.getUniquePoints(), thickness = 5.0)
        // get enemy route info
        val index = (enemy.getU(clock.now()) * 3).toInt() // plane index
        val otherOutline = buildOutlinePlanes(enemy.getUniquePoints(), thickness = 5.0)

        val length = min(pathOutline.size, otherOutline.size - index)
        for (i in 0 until length) {
            val plane = pathOutline[i]
            val otherPlaneIndex = i + index
            val otherPlane = otherOutline[otherPlaneIndex]
            // check if planes are overlapping
            if (plane.isOverlapping(otherPlane)) {
                val pathSegment = sampleSegmentOfBezier(beziers = movement.landmarks, u = i)
                val otherPathSegment = sampleSegmentOfBezier(beziers = enemy.landmarks, u = otherPlaneIndex)

                val t = comparePoints(pathSegment, otherPathSegment)
                val u = (t + i) / 3
                return movement.getInstant(u)
            }
        }
        return null
    }

    // split and sample line segment from [CubicBezier]
    private fun sampleSegmentOfBezier(beziers: List<CubicBezier>, u: Int): List<Position> {
        val s = u % 3
        return beziers[u / 3]
            .split(start = s / 3.0, end = (s + 1) / 3.0)
            .sample(numPoints = 5)
    }
}