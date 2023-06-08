package com.example.shipconquest.domain.ship.movement

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.event.event_details.updateMovement
import java.time.Instant

sealed interface Movement {
    fun build(instant: Instant, events: List<Event>): Movement {
        var currentMovement: Movement = this
        for(event in events) {
            // if ship is currently not in an event, then return current movement
            if (instant.isAfter(event.instant))
                currentMovement = when(val details = event.details) {
                    is FightEvent -> details.updateMovement(movement = this, instant = event.instant)
                    is IslandEvent -> details.updateMovement(movement = this, instant = event.instant)
                }
        }

        return currentMovement
    }
}