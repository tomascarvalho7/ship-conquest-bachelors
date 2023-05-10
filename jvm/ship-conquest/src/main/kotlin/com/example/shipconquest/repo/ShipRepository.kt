package com.example.shipconquest.repo

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.ship_navigation.ship.ShipBuilder
import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement
import com.example.shipconquest.repo.jdbi.dbmodel.ShipMovementDBModel
import org.slf4j.Logger
import java.time.Duration
import java.time.Instant

interface ShipRepository {
    val logger: Logger

    fun getShipBuilder(tag: String, shipId: Int, uid: String, instant: Instant): ShipBuilder?

    fun getShipsBuilder(tag: String, uid: String, instant: Instant): List<ShipBuilder>
    fun createShipPosition(
        tag: String,
        uid: String,
        points: List<Vector2>,
        startTime: Instant?,
        duration: Duration?
    )

    fun updateShipPosition(
        tag: String,
        uid: String,
        shipId: Int,
        points: List<Vector2>,
        startTime: Instant?,
        duration: Duration?
    )

    fun deleteShipEntry(tag: String, shipId: String, uid: String)

    fun checkShipPathExists(
        tag: String,
        shipId: String,
        uid: String,
    ): Boolean
}