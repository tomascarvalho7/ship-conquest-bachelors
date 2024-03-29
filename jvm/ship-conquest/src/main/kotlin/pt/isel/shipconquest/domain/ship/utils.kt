package pt.isel.shipconquest.domain.ship

import pt.isel.shipconquest.domain.event.Event
import pt.isel.shipconquest.domain.event.event_details.IslandEvent
import pt.isel.shipconquest.domain.ship.movement.Kinetic
import pt.isel.shipconquest.domain.ship.movement.Movement
import pt.isel.shipconquest.domain.utils.isBetween
import java.time.Instant

fun buildMovementFromEvents(movement: Movement, instant: Instant, events: List<Event>): Movement {
    var currentMovement: Movement = movement
    for(event in events) {
        // if ship is currently not in an event, then return current movement
        if (instant.isAfter(event.instant) && event.details is IslandEvent && currentMovement is Kinetic)
            currentMovement = shortenMovementUntilIsland(currentMovement, event.instant)
    }

    return currentMovement
}

// cut remaining movement after [IslandEvent]'s [Instant] occurs
private fun shortenMovementUntilIsland(kinetic: Kinetic, instant: Instant): Kinetic {
    return if(instant.isBetween(start = kinetic.startTime, end = kinetic.endTime))
        kinetic.shorten(instant)
    else kinetic
}