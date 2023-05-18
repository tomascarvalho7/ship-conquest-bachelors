package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.ship_navigation.ship.ShipInfo
import java.time.Duration
import java.time.Instant

data class ShipInfoDBModel(val shipId: Int, val movements: List<ShipMovementDBModel>)

data class ShipInfoDBModelExtended(
    val shipId: Int,
    val points: ShipPointsDBModel,
    val startTime: Instant?,
    val duration: Duration?
)

fun ShipInfoDBModelExtended.toShipInfoDBModel() =
    ShipInfoDBModel(shipId, listOf(ShipMovementDBModel(points, startTime, duration)))

fun ShipInfoDBModel.toShipInfo() =
    ShipInfo(id = shipId, movements = movements.map { it.toMovement() })