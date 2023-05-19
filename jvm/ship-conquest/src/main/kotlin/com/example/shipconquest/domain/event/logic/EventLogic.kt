package com.example.shipconquest.domain.event.logic

import com.example.shipconquest.Clock
import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.FightInteraction
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.logic.utils.plane.buildOutlinePlanes
import com.example.shipconquest.domain.event.logic.utils.plane.isOverlapping
import com.example.shipconquest.domain.bezier.CubicBezier
import com.example.shipconquest.domain.ship.ShipBuilder
import com.example.shipconquest.domain.ship.getMobileMovementOrNull
import com.example.shipconquest.domain.ship.movement.Mobile
import com.example.shipconquest.domain.bezier.utils.*
import com.example.shipconquest.domain.event.logic.utils.calculateWinner
import com.example.shipconquest.domain.event.logic.utils.comparePoints
import java.time.Instant

class EventLogic(private val clock: Clock) {
    fun buildFightEventsBetween(
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

    private fun getFirstIntersection(movement: Mobile, enemy: Mobile): Instant? {
        val pathOutline = buildOutlinePlanes(movement.getUniquePoints(), thickness = 5.0)
        // get enemy route info
        val index = (enemy.getU(clock.now()) * 3).toInt() // plane index
        val otherOutline = buildOutlinePlanes(enemy.getUniquePoints(), thickness = 5.0)

        for (i in pathOutline.indices) {
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

    private fun sampleSegmentOfBezier(beziers: List<CubicBezier>, u: Int): List<Position> {
        val s = u % 3
        return beziers[u / 3]
            .split(start = s / 3.0, end = (s + 1) / 3.0)
            .sample(numPoints = 5)
    }
}