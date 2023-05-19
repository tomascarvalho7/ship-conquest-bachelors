package com.example.shipconquest.domain.ship

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.FutureEvent
import com.example.shipconquest.domain.ship.movement.Mobile
import com.example.shipconquest.domain.ship.movement.Stationary
import java.time.Duration
import java.time.Instant

data class ShipBuilder(val info: ShipInfo, val events: List<Event>)

fun ShipBuilder.addEvents(newEvents: List<Event>) =
    ShipBuilder(info = info, events = events + newEvents)

fun ShipBuilder.build(instant: Instant) = Ship(
        sid = info.id,
        movement = info.getCurrentMovement().build(instant = instant, events = events),
        completedEvents = events.filter { it.instant.isBefore(instant) },
        futureEvents = events.filter { it.instant.isAfter(instant) }
            .map { event -> FutureEvent(event, Duration.between(instant, event.instant)) }
    )

fun ShipBuilder.getMobileMovementOrNull(instant: Instant) =
    when(val movement = info.getCurrentMovement().build(instant = instant, events = events)) {
        is Mobile -> movement
        is Stationary -> null
    }