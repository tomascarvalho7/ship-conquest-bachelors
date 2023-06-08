package com.example.shipconquest.repo

import com.example.shipconquest.domain.lobby.Limit
import com.example.shipconquest.domain.lobby.Lobby
import com.example.shipconquest.domain.lobby.Order
import com.example.shipconquest.domain.lobby.Skip
import org.slf4j.Logger

interface LobbyRepository {
    val logger: Logger

    fun get(tag: String): Lobby?
    fun createLobby(lobby: Lobby)
    fun joinLobby(uid: String, tag: String)
    fun checkUserInLobby(uid: String, tag: String): Boolean
    fun getList(skip: Skip, limit: Limit, order: Order): List<Lobby>
    fun getListByName(skip: Skip, limit: Limit, order: Order, name: String): List<Lobby>
}