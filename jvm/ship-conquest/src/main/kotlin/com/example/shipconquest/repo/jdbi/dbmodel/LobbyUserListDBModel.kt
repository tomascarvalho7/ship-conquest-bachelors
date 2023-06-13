package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.lobby.LobbyUser

data class LobbyUserDBModelList(val list: List<LobbyUserDBModel>)

fun List<LobbyUserDBModel>.toLobbyUserList() = map {lobby -> LobbyUser(lobby.lobby_tag, lobby.uid, lobby.is_favorite)}
