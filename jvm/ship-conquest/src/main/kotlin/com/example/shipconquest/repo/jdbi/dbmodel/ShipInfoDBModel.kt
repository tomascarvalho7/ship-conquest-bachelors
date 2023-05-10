package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.ship_navigation.ship.ShipBuilder

data class ShipInfoDBModel(val shipId: Int, val pos_info: ShipMovementDBModel)

fun ShipInfoDBModel.toShipBuilder(events: List<Event>) =
    ShipBuilder(id = shipId, movement = pos_info.toMovement(), events = events)