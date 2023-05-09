package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.lobby.*
import com.example.shipconquest.repo.LobbyRepository
import com.example.shipconquest.repo.jdbi.dbmodel.LobbyDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.LobbyListDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.toLobby
import com.example.shipconquest.repo.jdbi.dbmodel.toLobbyList
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.slf4j.Logger
import org.slf4j.LoggerFactory

class LobbyRepositoryJDBI(private val handle: Handle) : LobbyRepository {
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
                insert into dbo.Lobby(tag, name, uid, username, creationTime) values(:tag, :name, :uid, :username, :creationTime)
            """
        )
            .bind("tag", lobby.tag)
            .bind("name", lobby.name)
            .bind("uid", lobby.uid)
            .bind("username", lobby.username)
            .bind("creationTime", lobby.creationTime)
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

        val count = handle.createQuery(
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

    override fun getList(skip: Skip, limit: Limit, order: Order): List<Lobby> {
        logger.info("Getting all lobbies from db")

        return handle.createQuery(
            """
               select * from dbo.Lobby ORDER BY creationTime ${order.toSQLOrder()} LIMIT :limit OFFSET :skip;
            """
        )
            .bind("limit", limit.value)
            .bind("skip", skip.value)
            .mapTo<LobbyDBModel>()
            .list()
            .toLobbyList()
    }

    override fun getListByName(skip: Skip, limit: Limit, order: Order, name: String): List<Lobby> {
        logger.info("Getting all lobbies from db with matching name {}", name)

        return handle.createQuery(
            """
               select * from dbo.Lobby lobby where lobby.name ILIKE :name ORDER BY creationTime ${order.toSQLOrder()} LIMIT :limit OFFSET :skip;
            """
        )
            .bind("name", "%$name%")
            .bind("limit", limit.value)
            .bind("skip", skip.value)
            .mapTo<LobbyDBModel>()
            .list()
            .toLobbyList()
    }
}