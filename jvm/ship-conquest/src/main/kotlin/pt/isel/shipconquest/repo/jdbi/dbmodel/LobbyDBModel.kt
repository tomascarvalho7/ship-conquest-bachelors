package pt.isel.shipconquest.repo.jdbi.dbmodel

import pt.isel.shipconquest.domain.lobby.Lobby


data class LobbyDBModel(val tag: String, val name: String, val uid: String, val username: String, val creationTime: Long)

fun LobbyDBModel.toLobby() = Lobby(tag, name, uid, username, creationTime)