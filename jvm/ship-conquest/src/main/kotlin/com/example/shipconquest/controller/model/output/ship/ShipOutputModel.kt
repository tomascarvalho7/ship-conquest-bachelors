package com.example.shipconquest.controller.model.output.ship

import com.example.shipconquest.domain.ship_navigation.ship.Ship
import java.time.Instant

data class ShipOutputModel(
    val sid: Int,
    val movement: MovementOutputModel,
    val completedEvents: List<KnownEventOutputModel>,
    val futureEvents: List<UnknownEventOutputModel>
)

fun Ship.toShipOutputModel() =
    ShipOutputModel(
        sid = sid,
        movement = movement.toMovementOutputModel(),
        completedEvents = completedEvents.map { it.toKnownEventOutputModel(sid) },
        futureEvents = futureEvents.map { it.toUnknownEventOutputModel() }
    )
