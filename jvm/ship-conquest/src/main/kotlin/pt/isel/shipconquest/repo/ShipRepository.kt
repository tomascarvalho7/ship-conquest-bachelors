package pt.isel.shipconquest.repo

import org.slf4j.Logger
import pt.isel.shipconquest.domain.ship.ShipInfo
import pt.isel.shipconquest.domain.ship.movement.Kinetic
import pt.isel.shipconquest.domain.space.Vector2
import java.time.Duration
import java.time.Instant

interface ShipRepository {
    val logger: Logger

    fun getShipInfo(tag: String, shipId: Int, uid: String): ShipInfo?

    fun getShipsInfo(tag: String, uid: String): List<ShipInfo>

    fun getOtherShipsInfo(tag: String, uid: String): List<ShipInfo>

    fun createShipInfo(
        tag: String,
        uid: String,
        points: List<Vector2>,
        startTime: Instant?,
        duration: Duration?
    ): ShipInfo

    fun updateShipInfo(
        tag: String,
        uid: String,
        shipId: Int,
        movement: Kinetic
    )

    fun deleteShipEntry(tag: String, shipId: String, uid: String)
}