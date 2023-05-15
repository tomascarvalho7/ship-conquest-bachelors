package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.ship_navigation.ship.ShipInfo

data class ShipInfoDBModel(val shipId: Int, val pos_info: ShipMovementDBModel)

fun ShipInfoDBModel.toShipInfo() =
    ShipInfo(id = shipId, movement = pos_info.toMovement())