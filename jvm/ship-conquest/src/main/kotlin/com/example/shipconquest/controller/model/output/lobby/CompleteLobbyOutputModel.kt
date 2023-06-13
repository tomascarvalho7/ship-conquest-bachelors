package com.example.shipconquest.controller.model.output.lobby

import com.example.shipconquest.domain.lobby.CompleteLobby

data class CompleteLobbyOutputModel(
    val tag: String,
    val name: String,
    val uid: String,
    val username: String,
    val creationTime: Long,
    val isFavorite: Boolean,
    val players: Int
)

fun CompleteLobby.toCompleteLobbyOutputModel() =
    CompleteLobbyOutputModel(tag, name, uid, username, creationTime, isFavorite, playerCount)