package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.ship_navigation.ship.movement.Mobile
import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement
import com.example.shipconquest.domain.ship_navigation.ship.movement.Stationary
import com.example.shipconquest.domain.toPosition
import com.example.shipconquest.repo.jdbi.serialization.DurationDeserializer
import com.example.shipconquest.repo.jdbi.serialization.DurationSerializer
import com.example.shipconquest.repo.jdbi.serialization.InstantDeserializer
import com.example.shipconquest.repo.jdbi.serialization.InstantSerializer
import com.example.shipconquest.service.buildBeziers
import com.fasterxml.jackson.databind.annotation.JsonDeserialize
import com.fasterxml.jackson.databind.annotation.JsonSerialize
import java.time.Duration
import java.time.Instant

data class ShipMovementDBModel(
    val points: Array<PositionDBModel>,
    @JsonSerialize(using = InstantSerializer::class)
    @JsonDeserialize(using = InstantDeserializer::class) val startTime: Instant?,
    @JsonSerialize(using = DurationSerializer::class)
    @JsonDeserialize(using = DurationDeserializer::class) val duration: Duration?
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as ShipMovementDBModel

        if (!points.contentEquals(other.points)) return false
        if (startTime != other.startTime) return false
        if (duration != other.duration) return false

        return true
    }

    override fun hashCode(): Int {
        var result = points.contentHashCode()
        result = 31 * result + startTime.hashCode()
        result = 31 * result + duration.hashCode()
        return result
    }
}

fun ShipMovementDBModel.toMovement(): Movement {
    if (startTime == null || duration == null) return Stationary(
        position = points[0].toVector2()
    )


    return Mobile(
        landmarks = buildBeziers(points.map { Vector2(it.x, it.y) }),
        startTime = startTime,
        duration = duration
    )
}
