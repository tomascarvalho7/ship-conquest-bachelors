package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.ship.ShipInfo
import com.example.shipconquest.domain.ship.movement.Kinetic
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.repo.ShipRepository
import com.example.shipconquest.repo.jdbi.dbmodel.*
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
                SELECT sid, points, startTime, duration 
                FROM dbo.Ship ship inner join dbo.ShipPath path ON path.sid = ship.shipId 
                WHERE ship.gameTag = :tag AND ship.uid = :uid AND ship.shipId = :sid
                """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("sid", shipId)
            .mapTo<ShipInfoDBModel>()
            .toList()
            .toShipInfo()
    }

    override fun getShipsInfo(tag: String, uid: String): List<ShipInfo> {
        logger.info("Getting ships info of user {} in lobby {}", uid, tag)

        return handle.createQuery(
            """
                SELECT sid, points, startTime, duration 
                FROM dbo.ShipPath 
                WHERE gameTag = :tag AND uid = :uid
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<ShipInfoDBModel>()
            .toList()
            .toShipInfoCollection()
    }

    override fun getOtherShipsInfo(tag: String, uid: String): List<ShipInfo> {
        logger.info("Getting other ships info of user {} in lobby {}", uid, tag)

        return handle.createQuery(
            """
                SELECT sid, points, startTime, duration 
                FROM dbo.ShipPath 
                WHERE gameTag = :tag AND uid != :uid
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<ShipInfoDBModel>()
            .toList()
            .toShipInfoCollection()
    }

    override fun createShipInfo(
        tag: String,
        uid: String,
        points: List<Vector2>,
        startTime: Instant?,
        duration: Duration?
    ): ShipInfo {
        logger.info("Creating a ship of user {} in lobby {}", uid, tag)

        val sid = handle.createUpdate(
            """
            insert into dbo.Ship (gameTag, uid) values(:tag, :uid);
        """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .executeAndReturnGeneratedKeys()
            .mapTo<Int>()
            .single()

        handle.createUpdate("""
            insert into dbo.ShipPath (gameTag, uid, sid, points, startTime, duration) 
            VALUES (:tag, :uid, :sid, :points, :startTime, :duration)
        """)
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("sid", sid)
            .bind(
                "points",
                PGobject().apply {
                    type = "jsonb"
                    value = serializeShipPosition(points)
                }
            )
            .bind("startTime", startTime?.epochSecond)
            .bind("duration", duration)
            .executeAndReturnGeneratedKeys()
            .mapTo<Int>()
            .single()

        return ShipInfo(sid, listOf(Stationary(points.first())))
    }

    override fun updateShipInfo(
        tag: String,
        uid: String,
        shipId: Int,
        movement: Kinetic
    ) {
        logger.info("Updating a ship's position of user {} in lobby {}", uid, tag)

        handle.createUpdate("""
            insert into dbo.ShipPath (gameTag, uid, sid, points, startTime, duration) VALUES (:tag, :uid, :sid, :points, :startTime, :duration)
        """)
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("sid", shipId)
            .bind(
                "points",
                PGobject().apply {
                    type = "jsonb"
                    value = serializeShipPosition(movement.getPoints())
                }
            )
            .bind("startTime", movement.startTime.epochSecond)
            .bind("duration", movement.duration)
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

        fun serializeShipPosition(position: List<Vector2>): String =
            objectMapper.writeValueAsString(ShipPointsDBModel(position.map { PositionDBModel(it.x, it.y) }
                .toTypedArray()))

        fun deserializeShipPosition(json: String) =
            objectMapper.readValue<ShipPointsDBModel>(json)
    }
}