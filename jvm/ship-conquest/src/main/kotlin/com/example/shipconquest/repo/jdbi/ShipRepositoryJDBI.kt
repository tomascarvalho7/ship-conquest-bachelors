package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.ship_navigation.ship.ShipBuilder
import com.example.shipconquest.domain.ship_navigation.ship.ShipInfo
import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement
import com.example.shipconquest.repo.ShipRepository
import com.example.shipconquest.repo.jdbi.dbmodel.*
import com.example.shipconquest.repo.jdbi.mapper.PositionMapper
import com.example.shipconquest.repo.jdbi.mapper.ShipPositionMapper
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.KotlinModule
import com.fasterxml.jackson.module.kotlin.readValue
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.postgresql.util.PGobject
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.time.Duration
import java.time.Instant

class ShipRepositoryJDBI(private val handle: Handle): ShipRepository {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)
    override fun getShipInfo(tag: String, shipId: Int, uid: String): ShipInfo? {
        logger.info("Getting ship {} info of user {} in lobby {}", shipId, uid, tag)

        return handle.createQuery(
            """
            select shipId, pos_info from dbo.ship where gameTag = :tag and uid = :uid and shipId = :shipId;
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("shipId", shipId)
            .mapTo<ShipInfoDBModel>()
            .singleOrNull()?.toShipInfo()
    }

    override fun getShipsInfo(tag: String, uid: String): List<ShipInfo> {
        logger.info("Getting ships info of user {} in lobby {}", uid, tag)

        return handle.createQuery(
            """
                SELECT shipId, pos_info FROM dbo.Ship WHERE gameTag = :tag AND uid = :uid
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<ShipInfoDBModel>()
            .map { it.toShipInfo() }
            .toList()
    }

    override fun createShipInfo(
        tag: String,
        uid: String,
        points: List<Vector2>,
        startTime: Instant?,
        duration: Duration?
    ) {
        logger.info("Creating a ship of user {} in lobby {}", uid, tag)

        handle.createUpdate(
            """
            insert into dbo.Ship (gameTag, uid, pos_info) values(:tag, :uid, :positionInfo);
        """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind(
                "positionInfo",
                PGobject().apply {
                    type = "jsonb"
                    value = serializeShipPosition(points, startTime, duration)
                }
            )
            .execute()
    }

    override fun updateShipInfo(
        tag: String,
        uid: String,
        shipId: Int,
        points: List<Vector2>,
        startTime: Instant?,
        duration: Duration?
    ) {
        logger.info("Updating a ship's position of user {} in lobby {}", uid, tag)

        handle.createUpdate(
            """
            update dbo.Ship SET gameTag = :tag, uid = :uid, pos_info = :positionInfo WHERE shipId = :shipId;
        """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind(
                "positionInfo",
                PGobject().apply {
                    type = "jsonb"
                    value = serializeShipPosition(points, startTime, duration)
                }
            )
            .bind("shipId", shipId)
            .execute()
    }

    override fun deleteShipEntry(tag: String, shipId: String, uid: String) {
        logger.info("Deleting the ship path of ship {} of user {} in lobby {}", shipId, uid, tag)

        handle.createUpdate("""
            delete from dbo.ShipPath where gameTag = :tag and uid = :uid and shipId = :shipId;
        """)
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("shipId", shipId)
            .execute()

        handle.createUpdate("""
            delete from dbo.ShipPosition where gameTag = :tag and uid = :uid and shipId = :shipId;
        """)
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("shipId", shipId)
            .execute()
    }

    companion object {
        private val objectMapper = ObjectMapper().registerModule(KotlinModule.Builder().build())

        fun serializeShipPosition(position: List<Vector2>, startTime: Instant?, duration: Duration?): String =
            objectMapper.writeValueAsString(ShipMovementDBModel(position.map { PositionDBModel(it.x, it.y) }
                .toTypedArray(), startTime, duration))

        fun deserializeShipPosition(json: String) =
            objectMapper.readValue<ShipMovementDBModel>(json)
    }
}