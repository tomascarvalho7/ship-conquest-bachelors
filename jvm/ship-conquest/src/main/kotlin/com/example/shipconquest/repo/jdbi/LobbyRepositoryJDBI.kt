package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.lobby.Lobby
import com.example.shipconquest.repo.LobbyRepository
import com.example.shipconquest.repo.jdbi.dbmodel.LobbyDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.LobbyListDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.toLobby
import com.example.shipconquest.repo.jdbi.dbmodel.toLobbyList
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

    override fun joinLobby(uid: String, tag: String) {
        logger.info("User {} joining lobby with tag = {}", uid, tag)

        handle.createUpdate(
            """
                insert into dbo.Lobby_User(lobby_tag, uid) values(:tag, :uid)
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .execute()
    }

    override fun checkUserInLobby(uid: String, tag: String): Boolean {
        logger.info("Checking if user {} exists in lobby with tag = {}", uid, tag)

        val count =  handle.createQuery(
            """
               select count(uid) from dbo.Lobby_User where lobby_tag = :tag AND uid = :uid; 
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<Int>()
            .single()

        return count == 1
    }

    override fun getAll(skip: Int, limit: Int): List<Lobby> {
        logger.info("Getting all lobbies from db")

        return handle.createQuery(
            """
               select * from dbo.Lobby ORDER BY tag ASC LIMIT :limit OFFSET :skip;
            """
        )
            .bind("limit", limit)
            .bind("skip", skip)
            .mapTo<LobbyDBModel>()
            .list()
            .toLobbyList()
    }
}