package com.example.shipconquest.controller.model.output.lobby

import com.example.shipconquest.domain.lobby.CompleteLobby

data class FavoriteLobbyOutputModel(
    val isFavorite: Boolean
)

fun Boolean.toFavoriteLobbyOutputModel() =
    FavoriteLobbyOutputModel(this)