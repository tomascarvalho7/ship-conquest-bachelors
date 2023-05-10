package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.ship_navigation.ship.ShipBuilder
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
    override fun getShipBuilder(tag: String, shipId: Int, uid: String, instant: Instant): ShipBuilder? {
        logger.info("Getting ship {} builder of user {} in lobby {}", shipId, uid, tag)

        val shipInfo = handle.createQuery(
            """
            select shipId, pos_info from dbo.ship where gameTag = :tag and uid = :uid and shipId = :shipId;
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("shipId", shipId)
            .mapTo<ShipInfoDBModel>()
            .singleOrNull() ?: return null

        val fightEvents = handle.createQuery(
            """
                SELECT * FROM dbo.FightEvent 
                WHERE tag = :tag AND instant > :instant AND (sidA = :sid OR sidB = :sid)
            """
        )
            .bind("tag", tag)
            .bind("sid", shipId)
            .bind("instant", instant.epochSecond)
            .mapTo<FightEventDBModel>()
            .toList()
            .map { it.toEvent() }

        val islandEvents = handle.createQuery(
            """
                SELECT * FROM dbo.IslandEvent 
                WHERE tag = :tag AND sid = :sid AND instant > :instant
            """
        )
            .bind("tag", tag)
            .bind("sid", shipId)
            .bind("instant", instant.epochSecond)
            .mapTo<IslandEventDBModel>()
            .toList()
            .map { it.toEvent() }

        return shipInfo.toShipBuilder(fightEvents + islandEvents)
    }

    override fun getShipsBuilder(tag: String, uid: String, instant: Instant): List<ShipBuilder> {
        logger.info("Getting ships movement of user {} in lobby {}", uid, tag)

        val shipsInfo = handle.createQuery(
            """
                SELECT shipId, pos_info FROM dbo.Ship WHERE gameTag = :tag AND uid = :uid
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<ShipInfoDBModel>()
            .toList()

        return List(shipsInfo.size) { index ->
            val shipInfo = shipsInfo[index]

            val fightEvents = handle.createQuery(
                """
                SELECT * FROM dbo.FightEvent 
                WHERE tag = :tag AND instant > :instant AND (sidA = :sid OR sidB = :sid)
            """
            )
                .bind("tag", tag)
                .bind("sid", shipInfo.shipId)
                .bind("instant", instant.epochSecond)
                .mapTo<FightEventDBModel>()
                .toList()
                .map { it.toEvent() }

            val islandEvents = handle.createQuery(
                """
                SELECT * FROM dbo.IslandEvent 
                WHERE tag = :tag AND sid = :sid AND instant > :instant
            """
            )
                .bind("tag", tag)
                .bind("sid", shipInfo.shipId)
                .bind("instant", instant.epochSecond)
                .mapTo<IslandEventDBModel>()
                .toList()
                .map { it.toEvent() }

            shipInfo.toShipBuilder(fightEvents + islandEvents)
        }
    }

    override fun createShipPosition(
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

    override fun updateShipPosition(
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

    override fun checkShipPathExists(tag: String, shipId: String, uid: String): Boolean {
        logger.info("Checking if ship {} path exists of user = {} lobby = {}", shipId, uid, tag)

        val result = handle.createQuery(
            """
               select static_position from dbo.ShipPath where gameTag = :tag AND uid = :uid AND shipId = :shipId
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("shipId", shipId)
            .map(PositionMapper())
            .singleOrNull()
        return result == null
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