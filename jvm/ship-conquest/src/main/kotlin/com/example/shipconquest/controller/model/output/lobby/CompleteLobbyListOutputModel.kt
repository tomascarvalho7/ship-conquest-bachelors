package com.example.shipconquest.controller.model.output.lobby


data class CompleteLobbyListOutputModel(val lobbies: List<CompleteLobbyOutputModel>)

fun List<CompleteLobbyOutputModel>.toCompleteLobbyOutputModel() =
    CompleteLobbyListOutputModel(this)