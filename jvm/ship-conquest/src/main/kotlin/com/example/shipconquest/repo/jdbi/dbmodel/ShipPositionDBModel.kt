package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.ship_navigation.ShipPath
import com.example.shipconquest.repo.jdbi.DurationDeserializer
import com.example.shipconquest.repo.jdbi.LocalDateTimeDeserializer
import com.example.shipconquest.service.buildBeziers
import com.fasterxml.jackson.databind.annotation.JsonDeserialize
import java.time.Duration
import java.time.LocalDateTime

data class ShipPositionDBModel(
    val points: Array<PositionDBModel>,
    @JsonDeserialize(using = LocalDateTimeDeserializer::class) val startTime: LocalDateTime?,
    @JsonDeserialize(using = DurationDeserializer::class) val duration: Duration?
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as ShipPositionDBModel

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

fun ShipPositionDBModel.toShipPath(): ShipPath? {
    if (startTime == null || duration == null) return null
    return ShipPath(
        landmarks = buildBeziers(points.map { Vector2(it.x, it.y) }),
        startTime = startTime,
        duration = duration
    )
}
