package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.lobby.Lobby

data class LobbyDBModel(val tag: String, val name: String, val uid: String, val username: String, val creationTime: Long)

fun LobbyDBModel.toLobby() = Lobby(tag, name, uid, username, creationTime)