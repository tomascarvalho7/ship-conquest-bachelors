package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.ship_navigation.ship.ShipInfo
import java.time.Duration
import java.time.Instant

data class ShipInfoDBModel(val shipId: Int, val pos_info: ShipMovementDBModel)

data class ShipInfoDBModelExtended(
    val shipId: Int,
    val points: ShipPointsDBModel,
    val startTime: Instant?,
    val duration: Duration?
)

fun ShipInfoDBModelExtended.toShipInfoDBModel() =
    ShipInfoDBModel(shipId, ShipMovementDBModel(points, startTime, duration))

fun List<ShipInfoDBModelExtended>.toShipInfoDBModelList() = map {
    ShipInfoDBModel(it.shipId, ShipMovementDBModel(it.points, it.startTime, it.duration))
}

fun List<ShipInfoDBModel>.toShipInfoList() = map {
    ShipInfo(it.shipId, it.pos_info.toMovement())
}

fun ShipInfoDBModel.toShipInfo() =
    ShipInfo(id = shipId, movement = pos_info.toMovement())