package pt.isel.shipconquest.controller.model.output.ship

import com.example.shipconquest.domain.ship.Fleet

data class FleetOutputModel(val ships: List<ShipOutputModel>)

fun Fleet.toFleetOutputModel() = FleetOutputModel(ships = ships.map { it.toShipOutputModel() })