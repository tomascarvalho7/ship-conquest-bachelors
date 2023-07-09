package pt.isel.shipconquest.repo.jdbi

import com.example.shipconquest.domain.lobby.*
import com.example.shipconquest.repo.LobbyRepository
import com.example.shipconquest.repo.jdbi.dbmodel.*
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
                insert into dbo.Lobby_User(tag, uid) values(:tag, :uid)
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .execute()
    }

    override fun setFavorite(uid: String, tag: String) {
        logger.info("Set favorite lobby for user {} with tag = {}", uid, tag)

        handle.createUpdate(
            """
                insert into dbo.Favorite_Lobbies(tag, uid) values(:tag, :uid)
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .execute()
    }

    override fun removeFavorite(uid: String, tag: String) {
        logger.info("Removing favorite lobby for user {} with tag = {}", uid, tag)

        handle.createUpdate(
            """
                delete from dbo.Favorite_Lobbies where tag = :tag AND uid = :uid
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("favorite", false)
            .execute()
    }

    override fun checkUserInLobby(uid: String, tag: String): Boolean {
        logger.info("Checking if user {} exists in lobby with tag = {}", uid, tag)

        val count = handle.createQuery(
            """
               select count(uid) from dbo.Lobby_User where tag = :tag AND uid = :uid; 
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<Int>()
            .single()

        return count == 1
    }

    override fun getList(uid: String, skip: Skip, limit: Limit, order: Order): List<LobbyInfo> {
        logger.info("Getting all lobbies from db")

        return handle.createQuery(
            """
               SELECT lobby.*, lobbyCount, CASE WHEN favorite_lobbies.tag IS NOT NULL THEN true 
               ELSE false END AS isFavorite FROM dbo.Lobby lobby LEFT JOIN (
                SELECT tag, COUNT(*) AS lobbyCount FROM dbo.Lobby_User GROUP BY tag
                ) lobby_user ON lobby.tag = lobby_user.tag
                LEFT JOIN dbo.Favorite_Lobbies favorite_lobbies 
                    ON lobby.tag = favorite_lobbies.tag 
                    AND favorite_lobbies.uid = :uid
                ORDER BY lobby.creationTime ${order.toSQLOrder()}
                LIMIT :limit OFFSET :skip;
            """
        )
            .bind("uid", uid)
            .bind("limit", limit.value)
            .bind("skip", skip.value)
            .mapTo<LobbyInfoDBModel>()
            .list()
            .toLobbyInfoList()
    }

    override fun getListByName(uid: String, skip: Skip, limit: Limit, order: Order, name: String): List<LobbyInfo> {
        logger.info("Getting all lobbies from db with matching name {}", name)

        return handle.createQuery(
            """
               SELECT lobby.*, lobbyCount, CASE WHEN favorite_lobbies.tag IS NOT NULL THEN true 
               ELSE false END AS isFavorite FROM dbo.Lobby lobby LEFT JOIN (
                SELECT tag, COUNT(*) AS lobbyCount FROM dbo.Lobby_User GROUP BY tag
                ) lobby_user ON lobby.tag = lobby_user.tag
                LEFT JOIN dbo.Favorite_Lobbies favorite_lobbies 
                    ON lobby.tag = favorite_lobbies.tag 
                    AND favorite_lobbies.uid = :uid WHERE lobby.name ILIKE :name
                ORDER BY lobby.creationTime ${order.toSQLOrder()}
                LIMIT :limit OFFSET :skip;
            """
        )
            .bind("uid", uid)
            .bind("name", "%$name%")
            .bind("limit", limit.value)
            .bind("skip", skip.value)
            .mapTo<LobbyInfoDBModel>()
            .list()
            .toLobbyInfoList()
    }

    override fun getRecentList(uid: String, skip: Skip, limit: Limit, order: Order): List<LobbyInfo> {
        logger.info("Getting all lobbies from db")

        return handle.createQuery(
            """
               WITH lobby_counts AS (
                    SELECT tag, COUNT(*) AS lobbyCount
                    FROM dbo.Lobby_User
                    WHERE uid = :uid
                    GROUP BY tag
                )
                SELECT lobby.*, lobbyCount,
                       CASE WHEN favorite_lobbies.tag IS NOT NULL THEN true ELSE false END AS isFavorite
                FROM dbo.Lobby lobby
                INNER JOIN lobby_counts lobby_user ON lobby.tag = lobby_user.tag
                LEFT JOIN dbo.Favorite_Lobbies favorite_lobbies ON lobby.tag = favorite_lobbies.tag 
                    AND favorite_lobbies.uid = :uid
                ORDER BY lobby.creationTime ${order.toSQLOrder()}
                LIMIT :limit OFFSET :skip;
            """
        )
            .bind("uid", uid)
            .bind("limit", limit.value)
            .bind("skip", skip.value)
            .mapTo<LobbyInfoDBModel>()
            .list()
            .toLobbyInfoList()
    }

    override fun getRecentListByName(
        uid: String,
        skip: Skip,
        limit: Limit,
        order: Order,
        name: String
    ): List<LobbyInfo> {
        logger.info("Getting recent lobbies from db with matching name {}", name)

        return handle.createQuery(
            """
               WITH lobby_counts AS (
                   SELECT tag, COUNT(*) AS lobbyCount
                   FROM dbo.Lobby_User
                   WHERE uid = :uid
                   GROUP BY tag
               )
               SELECT lobby.*, lobbyCount,
                      CASE WHEN favorite_lobbies.tag IS NOT NULL THEN true ELSE false END AS isFavorite
               FROM dbo.Lobby lobby
               INNER JOIN lobby_counts lobby_user ON lobby.tag = lobby_user.tag
               LEFT JOIN dbo.Favorite_Lobbies favorite_lobbies ON lobby.tag = favorite_lobbies.tag 
               AND favorite_lobbies.uid = :uid WHERE lobby.name ILIKE :name 
               ORDER BY lobby.creationTime ${order.toSQLOrder()}
               LIMIT :limit OFFSET :skip;
            """
        )
            .bind("uid", uid)
            .bind("name", "%$name%")
            .bind("limit", limit.value)
            .bind("skip", skip.value)
            .mapTo<LobbyInfoDBModel>()
            .list()
            .toLobbyInfoList()
    }

    override fun getFavoriteList(uid: String, skip: Skip, limit: Limit, order: Order): List<LobbyInfo> {
        logger.info("Getting favorite lobbies from db")

        return handle.createQuery(
            """
                SELECT lobby.*, COUNT(*) AS lobbyCount, true AS isFavorite FROM dbo.Lobby lobby
                INNER JOIN dbo.Favorite_Lobbies favorite ON lobby.tag = favorite.tag
                LEFT JOIN dbo.Lobby_User lobby_user ON lobby.tag = lobby_user.tag
                WHERE lobby_user.tag = lobby.tag AND favorite.uid = :uid GROUP BY lobby.tag
                ORDER BY lobby.creationTime ${order.toSQLOrder()} LIMIT :limit OFFSET :skip;
            """
        )
            .bind("uid", uid)
            .bind("limit", limit.value)
            .bind("skip", skip.value)
            .mapTo<LobbyInfoDBModel>()
            .list()
            .toLobbyInfoList()
    }

    override fun getFavoriteListByName(
        uid: String,
        skip: Skip,
        limit: Limit,
        order: Order,
        name: String
    ): List<LobbyInfo> {
        logger.info("Getting favorite lobbies from db with matching name {}", name)

        return handle.createQuery(
            """
                SELECT lobby.*, COUNT(*) AS lobbyCount, true AS isFavorite FROM dbo.Lobby lobby
                INNER JOIN dbo.Favorite_Lobbies favorite ON lobby.tag = favorite.tag
                LEFT JOIN dbo.Lobby_User lobby_user ON lobby.tag = lobby_user.tag
                WHERE lobby_user.tag = lobby.tag AND favorite.uid = :uid and lobby.name ILIKE :name
                GROUP BY lobby.tag ORDER BY lobby.creationTime ${order.toSQLOrder()} LIMIT :limit OFFSET :skip;
            """
        )
            .bind("uid", uid)
            .bind("name", "%$name%")
            .bind("limit", limit.value)
            .bind("skip", skip.value)
            .mapTo<LobbyInfoDBModel>()
            .list()
            .toLobbyInfoList()
    }
}