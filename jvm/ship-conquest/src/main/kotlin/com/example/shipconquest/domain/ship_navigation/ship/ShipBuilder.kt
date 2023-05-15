package com.example.shipconquest.domain.ship_navigation.ship

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.event.event_details.updateMovement
import com.example.shipconquest.domain.event.toUnknownEvent
import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement
import java.time.Instant

data class ShipBuilder(val info: ShipInfo, val events: List<Event>)

fun ShipBuilder.build(instant: Instant) = Ship(
        sid = info.id,
        movement = info.getCurrentMovement(instant = instant, events),
        completedEvents = events
            .filter { it.instant.isBefore(instant) },
        futureEvents = events
            .filter { it.instant.isAfter(instant) }
            .map { it.toUnknownEvent(instant) }
    )