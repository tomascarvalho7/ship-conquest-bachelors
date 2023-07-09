package pt.isel.shipconquest.repo.jdbi.dbmodel

import pt.isel.shipconquest.domain.lobby.LobbyInfo


data class LobbyInfoDBModel(
    val tag: String,
    val name: String,
    val uid: String,
    val username: String,
    val creationTime: Long,
    val isFavorite: Boolean,
    val lobbyCount: Int
)

fun List<LobbyInfoDBModel>.toLobbyInfoList() =
    map { LobbyInfo(it.tag, it.name, it.uid, it.username, it.creationTime, it.isFavorite, it.lobbyCount) }