package pt.isel.shipconquest.controller.model.output.ship

import pt.isel.shipconquest.domain.ship.Fleet


data class FleetOutputModel(val ships: List<ShipOutputModel>)

fun Fleet.toFleetOutputModel() = FleetOutputModel(ships = ships.map { it.toShipOutputModel() })