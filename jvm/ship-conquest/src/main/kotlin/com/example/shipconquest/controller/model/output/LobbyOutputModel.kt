package com.example.shipconquest.controller.model.output

import com.example.shipconquest.domain.lobby.Lobby

data class LobbyOutputModel(val tag: String, val name: String)

fun Lobby.toLobbyOutputModel() = LobbyOutputModel(tag = tag, name = name)