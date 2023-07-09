package pt.isel.shipconquest.domain.ship

import pt.isel.shipconquest.domain.ship.movement.Movement


/**
 * The [ShipInfo] data class holds only the data related to the ship and it's movements
 */
data class ShipInfo(val id: Int, val movements: List<Movement>)

// get last movement
fun ShipInfo.getCurrentMovement() = movements.last()

// add new movement to the lists of movements
fun ShipInfo.addMovement(movement: Movement) = ShipInfo(id = id, movements = movements.plus(movement))