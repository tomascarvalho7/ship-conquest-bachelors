package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.lobby.LobbyUser

data class LobbyUserDBModel(val lobby_tag: String, val uid: String, val is_favorite: Boolean)

fun LobbyUserDBModel.toLobbyUser() = LobbyUser(lobby_tag, uid, is_favorite)