package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.Game
import com.example.shipconquest.domain.world.HeightMap
import com.example.shipconquest.repo.GameRepository
import com.example.shipconquest.repo.jdbi.dbmodel.*
import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.module.kotlin.KotlinModule
import com.fasterxml.jackson.module.kotlin.readValue
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.jdbi.v3.core.statement.Update
import org.postgresql.util.PGobject
import org.slf4j.Logger
import org.slf4j.LoggerFactory

class GameRepositoryJDBI(private val handle: Handle): GameRepository {
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
    }
}