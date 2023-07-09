package pt.isel.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.ship.ShipInfo
import java.time.Duration
import java.time.Instant

data class ShipInfoDBModel(
    val sid: Int,
    val points: ShipPointsDBModel,
    val startTime: Instant?,
    val duration: Duration?
)

fun List<ShipInfoDBModel>.toShipInfoCollection() =
    groupBy { info -> info.sid }
        .map { (key, value) -> shipInfo(id = key, dataset = value) }

fun List<ShipInfoDBModel>.toShipInfo() =
    toShipInfoCollection()
        .firstOrNull()

fun shipInfo(id: Int, dataset: List<ShipInfoDBModel>) = ShipInfo(
        id = id,
        movements = dataset.mapNotNull { info ->
            ShipMovementDBModel(info.points, info.startTime, info.duration).toMovement()
        }
    )