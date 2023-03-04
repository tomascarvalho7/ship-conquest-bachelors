package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.lobby.Lobby

data class LobbyDBModel(val tag: String, val name: String)

fun LobbyDBModel.toLobby() = Lobby(tag, name)