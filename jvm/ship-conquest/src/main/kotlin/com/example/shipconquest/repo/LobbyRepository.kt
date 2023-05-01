package com.example.shipconquest.repo

import com.example.shipconquest.domain.lobby.Lobby
import org.slf4j.Logger

interface LobbyRepository {
    val logger: Logger

    fun get(tag: String): Lobby?
    fun createLobby(lobby: Lobby)
    fun joinLobby(uid: String, tag: String)
    fun checkUserInLobby(uid: String, tag: String): Boolean
    fun getAll(skip: Int, limit: Int): List<Lobby>
}