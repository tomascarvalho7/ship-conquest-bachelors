package com.example.shipconquest.controller.model.output.ship

import com.example.shipconquest.controller.model.output.Vector2OutputModel
import com.example.shipconquest.controller.model.output.toVector2OutputModel
import com.example.shipconquest.domain.ship.movement.Kinetic
import com.example.shipconquest.domain.ship.movement.Movement
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.domain.utils.formatDuration

interface MovementOutputModel

data class MobileOutputModel(
    val points: List<Vector2OutputModel>,
    val startTime: String,
    val duration: String
): MovementOutputModel

data class StationaryOutputModel(val coord: Vector2OutputModel): MovementOutputModel

fun Movement.toMovementOutputModel() =
    when (this) {
        is Kinetic -> MobileOutputModel(
            points = getPoints().map { it.toVector2OutputModel() },
            startTime = startTime.toString(),
            duration = formatDuration(duration)
        )
        is Stationary -> StationaryOutputModel(coord = coordinate.toVector2OutputModel())
    }