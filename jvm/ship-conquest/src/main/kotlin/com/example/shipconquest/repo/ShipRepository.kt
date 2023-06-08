package com.example.shipconquest.repo


import com.example.shipconquest.domain.ship.Ship
import com.example.shipconquest.domain.ship.ShipInfo
import com.example.shipconquest.domain.ship.movement.Mobile
import com.example.shipconquest.domain.ship.movement.Movement
import com.example.shipconquest.domain.space.Vector2
import org.slf4j.Logger
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
        movement: Mobile
    )

    fun deleteShipEntry(tag: String, shipId: String, uid: String)
}