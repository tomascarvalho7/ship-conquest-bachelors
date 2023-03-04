package com.example.shipconquest.repo

import com.example.shipconquest.domain.lobby.Lobby
import org.slf4j.Logger

interface LobbyRepository {
    val logger: Logger

    fun get(tag: String): Lobby?
    fun createLobby(lobby: Lobby)
}