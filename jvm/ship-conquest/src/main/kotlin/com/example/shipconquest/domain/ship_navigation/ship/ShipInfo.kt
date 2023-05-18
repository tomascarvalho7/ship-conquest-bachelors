package com.example.shipconquest.domain.ship_navigation.ship

import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement

data class ShipInfo(val id: Int, val movements: List<Movement>)

