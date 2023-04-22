package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.Game
import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.ship_navigation.CubicBezier
import com.example.shipconquest.domain.ship_navigation.ShipPath
import com.example.shipconquest.domain.world.HeightMap
import com.example.shipconquest.repo.GameRepository
import com.example.shipconquest.repo.jdbi.dbmodel.*
import com.example.shipconquest.repo.jdbi.mapper.PositionMapper
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.KotlinModule
import com.fasterxml.jackson.module.kotlin.readValue
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.jdbi.v3.core.statement.Update
import org.postgresql.util.PGobject
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.time.Duration
import java.time.LocalDateTime

class GameRepositoryJDBI(private val handle: Handle) : GameRepository {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)
    override fun get(tag: String): Game? {
        logger.info("Getting game from db with tag = {}", tag)

        return handle.createQuery(
            """
               select * from dbo.Game where tag = :tag 
            """
        )
            .bind("tag", tag)
            .mapTo<GameDBModel>()
            .singleOrNull()
            ?.toGame()
    }

    override fun getVisitedPoints(tag: String, uid: String): List<Vector2>? {
        logger.info("Getting visited spots from db with tag = {}", tag)

        return handle.createQuery(
            """
                   select points from dbo.VisitedPoints where gameTag = :tag AND uid = :uid
                """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<Array<PositionDBModel>>()
            .singleOrNull()
            ?.toPositionList()
    }

    override fun createGame(game: Game) {
        logger.info("Creating game from db with tag = {}", game.tag)

        handle.createUpdate(
            """
                insert into dbo.Game(tag, map) values(:tag, :map)
            """
        )
            .bind("tag", game.tag)
            .bindJson("map", game.map, ::serializeGameMap)
            .execute()
    }

    override fun createVisitedPoint(tag: String, uid: String, point: Vector2) {
        logger.info("Adding a new visited point for user = {} in game = {}", uid, tag)

        handle.createUpdate(
            """
                INSERT INTO dbo.VisitedPoints values(:gameTag, :uid, :point)
            """
        )
            .bind("gameTag", tag)
            .bind("uid", uid)
            .bindJson("point", point, ::serializePositionList)
            .execute()
    }

    override fun addVisitedPoint(tag: String, uid: String, point: Vector2) {
        logger.info("Adding a new visited point for user = {} in game = {}", uid, tag)

        handle.createUpdate(
            """
                UPDATE dbo.VisitedPoints SET points = points || :point where gameTag = :gameTag AND uid= :uid
            """
        )
            .bind("gameTag", tag)
            .bind("uid", uid)
            .bindJson("point", point, ::serializePosition)
            .execute()
    }

    override fun checkVisitedPointsExist(tag: String, uid: String): Boolean {
        logger.info("Checking if user = {} has visited points in game = {}", uid, tag)

        val count = handle.createQuery(
            """
               select count(*) from dbo.VisitedPoints where gameTag = :tag AND uid = :uid
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<Int>()
            .single()
        return count == 0
    }

    override fun getShipPath(tag: String, shipId: String, uid: String): ShipPath? {
        logger.info("Getting ship {} path of user {} in lobby {}", shipId, uid, tag)

        return handle.createQuery("""
            select landmarks, startTime, duration from dbo.shippath where gameTag = :tag and uid = :uid and shipId = :shipId;
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("shipId", shipId)
            .mapTo<ShipPathDBModel>()
            .singleOrNull()
            ?.toShipPath()
    }

    override fun createShipPath(
        tag: String,
        shipId: String,
        uid: String,
        landmarks: List<CubicBezier>,
        startTime: LocalDateTime,
        duration: Duration
    ) {
        logger.info("Creating a ship path of ship {} of user {} in lobby {}", shipId, uid, tag)

        handle.createUpdate("""
            insert into dbo.ShipPath values(:tag, :uid, :shipId, :landmarks, :startTime, :duration);
        """)
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("shipId", shipId)
            .bindJson("landmarks", landmarks, ::serializeCubicBezierList)
            .bind("startTime", startTime)
            .bind("duration", duration)
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

    override fun getShipStaticPosition(tag: String, shipId: String, uid: String): Vector2? {
        logger.info("Getting static ship position of ship {} of user {} in lobby {}", shipId, uid, tag)

        return handle.createQuery("""
            select static_position from dbo.shipposition where gameTag = :tag and uid = :uid and shipId = :shipId;
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("shipId", shipId)
            .map(PositionMapper())
            .singleOrNull()
            ?.toPosition()
    }

    override fun createShipStaticPosition(tag: String, shipId: String, uid: String, staticPosition: Vector2) {
        logger.info("Creating a ship static position of ship {} of user {} in lobby {}", shipId, uid, tag)

        handle.createUpdate("""
            insert into dbo.ShipPosition values(:tag, :uid, :shipId, :static_pos);
        """)
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("shipId", shipId)
            .bindJson("static_pos", staticPosition, ::serializePosition)
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
        private fun <J> Update.bindJson(name: String, json: J, serializeFn: (J) -> String) = run {
            bind(
                name,
                PGobject().apply {
                    type = "jsonb"
                    value = serializeFn(json)
                }
            )
        }

        private val objectMapper = ObjectMapper().registerModule(KotlinModule.Builder().build())

        fun serializeGameMap(map: HeightMap): String =
            objectMapper.writeValueAsString(map.toHeightMapDBModel())

        fun deserializeGameMap(json: String) =
            objectMapper.readValue<HeightMapDBModel>(json)

        fun serializePosition(position: Vector2): String =
            objectMapper.writeValueAsString(position.toPositionDBModel())

        fun deserializePosition(json: String?): PositionDBModel? {
            if(json != null) {
                return objectMapper.readValue<PositionDBModel>(json)
            } else return null
        }
        fun serializePositionList(position: Vector2): String =
            objectMapper.writeValueAsString(listOf(position.toPositionDBModel()))

        fun deserializePositionList(json: String) =
            objectMapper.readValue<Array<PositionDBModel>>(json)

        fun serializeCubicBezier(bezier: CubicBezier): String =
            objectMapper.writeValueAsString(bezier.toCubicBezierDBModel())

        fun deserializeCubicBezier(json: String) =
            objectMapper.readValue<CubicBezierDBModel>(json)

        fun serializeCubicBezierList(bezierList: List<CubicBezier>): String =
            objectMapper.writeValueAsString(bezierList.toCubicBezierDBModelList())

        fun deserializeCubicBezierList(json:String) =
            objectMapper.readValue<Array<CubicBezierDBModel>>(json)
    }
}