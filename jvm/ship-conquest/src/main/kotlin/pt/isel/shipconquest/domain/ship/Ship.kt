package pt.isel.shipconquest.domain.ship

import pt.isel.shipconquest.domain.event.Event
import pt.isel.shipconquest.domain.event.FutureEvent
import pt.isel.shipconquest.domain.ship.movement.Movement


/**
 * The [Ship] data class holds the static representation of a ship along a given
 * movement and the list of completed and future events born from this movement.
 */
data class Ship(
    val sid: Int,
    val movement: Movement,
    val completedEvents: List<Event>,
    val futureEvents: List<FutureEvent>
)