package com.example.shipconquest.controller.model.output.ship

import com.example.shipconquest.controller.model.output.Vector2OutputModel
import com.example.shipconquest.controller.model.output.toVector2OutputModel
import com.example.shipconquest.domain.ship.movement.Mobile
import com.example.shipconquest.domain.ship.movement.Movement
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.service.formatDuration

interface MovementOutputModel

data class MobileOutputModel(
    val points: List<Vector2OutputModel>,
    val startTime: String,
    val duration: String
): MovementOutputModel

data class StationaryOutputModel(val coord: Vector2OutputModel): MovementOutputModel

fun Movement.toMovementOutputModel() =
    when (this) {
        is Mobile -> MobileOutputModel(
            points = getPoints().map { it.toVector2OutputModel() },
            startTime = startTime.toString(),
            duration = formatDuration(duration)
        )
        is Stationary -> StationaryOutputModel(coord = position.toVector2OutputModel())
    }