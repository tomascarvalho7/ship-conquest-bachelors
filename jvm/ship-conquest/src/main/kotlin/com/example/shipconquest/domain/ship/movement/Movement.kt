package com.example.shipconquest.domain.ship.movement

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.utils.isBetween
import java.time.Instant

sealed interface Movement {
    fun buildEvents(instant: Instant, events: List<Event>): Movement {
        var currentMovement: Movement = this
        for(event in events) {
            // if ship is currently not in an event, then return current movement
            if (instant.isAfter(event.instant) && event.details is IslandEvent && currentMovement is Kinetic)
                currentMovement = shortenMovementUntilIsland(currentMovement, instant)
        }

        return currentMovement
    }

    fun build(instant: Instant, events: List<Event>): Movement {
        val movement = buildEvents(instant = instant, events = events)

        return if (movement is Kinetic && movement.endTime.isBefore(instant))
            Stationary(position = movement.spline.getFinalCoord())
        else movement
    }
}

// cut remaining movement after [IslandEvent]'s [Instant] occurs
fun shortenMovementUntilIsland(kinetic: Kinetic, instant: Instant): Kinetic {
    return if(instant.isBetween(start = kinetic.startTime, end = kinetic.endTime))
        kinetic.shorten(instant)
    else kinetic
}