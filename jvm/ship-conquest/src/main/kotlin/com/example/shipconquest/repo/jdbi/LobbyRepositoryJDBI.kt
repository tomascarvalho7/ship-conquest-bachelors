package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.lobby.Lobby
import com.example.shipconquest.repo.LobbyRepository
import com.example.shipconquest.repo.jdbi.dbmodel.LobbyDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.toLobby
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.slf4j.Logger
import org.slf4j.LoggerFactory

class LobbyRepositoryJDBI(private val handle: Handle): LobbyRepository {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)
    override fun get(tag: String): Lobby? {
        logger.info("Getting lobby from db with tag = {}", tag)

        return handle.createQuery(
            """
               select * from dbo.Lobby where tag = :tag 
            """
        )
            .bind("tag", tag)
            .mapTo<LobbyDBModel>()
            .singleOrNull()
            ?.toLobby()
    }

    override fun createLobby(lobby: Lobby) {
        logger.info("Creating lobby from db with tag = {}", lobby.tag)

        handle.createUpdate(
            """
                insert into dbo.Lobby(tag, name) values(:tag, :name)
            """
        )
            .bind("tag", lobby.tag)
            .bind("name", lobby.name)
            .execute()
    }
}