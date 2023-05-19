package com.example.shipconquest.domain.ship

import com.example.shipconquest.domain.ship.movement.Movement

data class ShipInfo(val id: Int, val movements: List<Movement>)

fun ShipInfo.getCurrentMovement() = movements.last()