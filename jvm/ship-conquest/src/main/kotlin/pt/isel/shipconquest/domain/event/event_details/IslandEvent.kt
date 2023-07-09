package pt.isel.shipconquest.domain.event.event_details

import pt.isel.shipconquest.domain.world.islands.Island


/**
 * The [IslandEvent] data class holds the data for the details of an event
 * of a ship going across an unknown [Island].
 * The [sid] value represents the ship-id of the ship, and [island] is the
 * found unknown [Island].
 */
data class IslandEvent(val sid: Int, val island: Island): EventDetails
