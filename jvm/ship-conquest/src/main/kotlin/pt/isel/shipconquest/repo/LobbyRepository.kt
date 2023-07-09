package pt.isel.shipconquest.repo

import com.example.shipconquest.domain.lobby.*
import org.slf4j.Logger

interface LobbyRepository {
    val logger: Logger

    fun get(tag: String): Lobby?
    fun createLobby(lobby: Lobby)
    fun joinLobby(uid: String, tag: String)
    fun setFavorite(uid: String, tag: String)
    fun removeFavorite(uid: String, tag: String)
    fun checkUserInLobby(uid: String, tag: String): Boolean
    fun getList(uid: String, skip: Skip, limit: Limit, order: Order): List<LobbyInfo>
    fun getListByName(uid: String, skip: Skip, limit: Limit, order: Order, name: String): List<LobbyInfo>
    fun getRecentList(uid: String, skip: Skip, limit: Limit, order: Order): List<LobbyInfo>
    fun getRecentListByName(uid: String, skip: Skip, limit: Limit, order: Order, name: String): List<LobbyInfo>
    fun getFavoriteList(uid: String, skip: Skip, limit: Limit, order: Order): List<LobbyInfo>
    fun getFavoriteListByName(uid: String, skip: Skip, limit: Limit, order: Order, name: String): List<LobbyInfo>
}