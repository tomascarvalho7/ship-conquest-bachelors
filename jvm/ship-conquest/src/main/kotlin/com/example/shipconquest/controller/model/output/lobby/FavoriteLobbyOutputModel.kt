package com.example.shipconquest.controller.model.output.lobby

data class FavoriteLobbyOutputModel(
    val isFavorite: Boolean
)

fun Boolean.toFavoriteLobbyOutputModel() =
    FavoriteLobbyOutputModel(this)