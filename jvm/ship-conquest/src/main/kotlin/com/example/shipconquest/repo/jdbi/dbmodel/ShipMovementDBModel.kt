package com.example.shipconquest.repo.jdbi.dbmodel


import com.example.shipconquest.domain.ship.movement.Mobile
import com.example.shipconquest.domain.ship.movement.Movement
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.service.buildBeziers
import java.time.Duration
import java.time.Instant

data class ShipMovementDBModel(
    val points: ShipPointsDBModel,
    val startTime: Instant?,
    val duration: Duration?
)

data class ShipPointsDBModel(
    val points: Array<PositionDBModel>,
) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as ShipPointsDBModel

        if (!points.contentEquals(other.points)) return false

        return true
    }

    override fun hashCode(): Int {
        return points.contentHashCode()
    }
}


fun ShipMovementDBModel.toMovement(): Movement {
    if (startTime == null || duration == null) return Stationary(
        position = points.points[0].toVector2()
    )


    return Mobile(
        landmarks = buildBeziers(points.points.map { Vector2(it.x, it.y) }),
        startTime = startTime,
        duration = duration
    )
}
