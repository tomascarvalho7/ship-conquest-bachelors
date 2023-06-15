package com.example.shipconquest.domain.ship

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.FutureEvent
import com.example.shipconquest.domain.ship.movement.Kinetic
import com.example.shipconquest.domain.ship.movement.Stationary
import java.time.Duration
import java.time.Instant


/**
 * The [ShipBuilder] class holds the builder representation of the resulting [Ship] class.
 *
 * Contains the ship movement data as well as all the events of the last movement.
 */
class ShipBuilder(val info: ShipInfo, val events: List<Event>) {
    // add event to list of events
    fun addEvents(newEvents: List<Event>) = ShipBuilder(info = info, events = events + newEvents)

    // [Ship] builder function
    fun build(instant: Instant) = Ship(
        sid = info.id,
        movement = info.getCurrentMovement().buildEvents(instant = instant, events = events),
        completedEvents = events.filter { it.instant.isBefore(instant) },
        futureEvents = events.filter { it.instant.isAfter(instant) }
            .map { event -> FutureEvent(event, Duration.between(instant, event.instant)) }
    )

    // get last mobile movement or null
    fun getMobileMovementOrNull(instant: Instant) =
        when(val movement = info.getCurrentMovement().buildEvents(instant = instant, events = events)) {
            is Kinetic -> if (movement.getEndTime().isAfter(instant)) movement else null
            is Stationary -> null
        }
}