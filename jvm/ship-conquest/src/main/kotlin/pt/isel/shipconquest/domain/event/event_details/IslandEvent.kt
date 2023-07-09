package pt.isel.shipconquest.domain.event.event_details

import com.example.shipconquest.domain.ship.movement.Kinetic
import com.example.shipconquest.domain.ship.movement.Movement
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.domain.utils.isBetween
import com.example.shipconquest.domain.world.islands.Island
import java.time.Duration
import java.time.Instant

/**
 * The [IslandEvent] data class holds the data for the details of an event
 * of a ship going across an unknown [Island].
 * The [sid] value represents the ship-id of the ship, and [island] is the
 * found unknown [Island].
 */
data class IslandEvent(val sid: Int, val island: Island): EventDetails
