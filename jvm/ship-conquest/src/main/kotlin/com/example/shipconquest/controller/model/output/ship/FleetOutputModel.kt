package com.example.shipconquest.controller.model.output.ship

import com.example.shipconquest.domain.ship_navigation.ship.Fleet

data class FleetOutputModel(val ships: List<ShipOutputModel>)

fun Fleet.toFleetOutputModel() = FleetOutputModel(ships = ships.map { it.toShipOutputModel() })