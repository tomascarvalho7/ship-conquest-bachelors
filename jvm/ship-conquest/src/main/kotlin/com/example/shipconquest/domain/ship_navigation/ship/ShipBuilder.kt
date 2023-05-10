package com.example.shipconquest.domain.ship_navigation.ship

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.event.event_details.updateMovement
import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement
import java.time.Instant

data class ShipBuilder(val id: Int, val movement: Movement, val events: List<Event>)

fun ShipBuilder.getCurrentMovement(instant: Instant): Movement {
    var currentMovement = movement
    for(event in events) {
        // if ship is currently not in an event, then return current movement
        if (instant.isAfter(event.instant))
            currentMovement = when(val details = event.details) {
                is FightEvent -> details.updateMovement(movement = movement, instant = event.instant)
                is IslandEvent -> details.updateMovement(movement = movement, instant = event.instant)
            }
    }
    return currentMovement
}

fun ShipBuilder.build(instant: Instant) = Ship(
        sid = id,
        movement = getCurrentMovement(instant = instant),
        completedEvents = events.filter { it.instant.isBefore(instant) },
        futureEvents = events.filter { it.instant.isAfter(instant) }
    )