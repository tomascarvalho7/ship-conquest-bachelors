package com.example.shipconquest.repo

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.ship_navigation.ship.ShipBuilder
import com.example.shipconquest.domain.ship_navigation.ship.ShipInfo
import org.slf4j.Logger
import java.time.Duration
import java.time.Instant

interface ShipRepository {
    val logger: Logger

    fun getShipInfo(tag: String, shipId: Int, uid: String): ShipInfo?

    fun getShipsInfo(tag: String, uid: String): List<ShipInfo>
    fun createShipInfo(
        tag: String,
        uid: String,
        points: List<Vector2>,
        startTime: Instant?,
        duration: Duration?
    )

    fun updateShipInfo(
        tag: String,
        uid: String,
        shipId: Int,
        points: List<Vector2>,
        startTime: Instant?,
        duration: Duration?
    )

    fun deleteShipEntry(tag: String, shipId: String, uid: String)
}