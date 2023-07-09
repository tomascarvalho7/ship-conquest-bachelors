package pt.isel.shipconquest.repo.jdbi.dbmodel

import pt.isel.shipconquest.domain.bezier.utils.buildSpline
import pt.isel.shipconquest.domain.ship.movement.Kinetic
import pt.isel.shipconquest.domain.ship.movement.Movement
import pt.isel.shipconquest.domain.ship.movement.Stationary
import pt.isel.shipconquest.domain.space.Vector2
import java.time.Duration
import java.time.Instant

data class ShipMovementDBModel(
    val spline: ShipPointsDBModel,
    val startTime: Instant?,
    val duration: Duration?
)

data class ShipPointsDBModel(val points: List<PositionDBModel>)

fun ShipMovementDBModel.toMovement(): Movement? {
    if (spline.points.isEmpty()) return null // empty list of points is not acceptable
    if (startTime == null || duration == null) return Stationary(
        coordinate = spline.points[0].toVector2()
    )

    return Kinetic(
        spline = buildSpline(spline.points.map { Vector2(it.x, it.y) }) ?: return null,
        startTime = startTime,
        duration = duration
    )
}
