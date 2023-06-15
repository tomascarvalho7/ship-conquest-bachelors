package com.example.shipconquest.domain.lobby

/**
 * The [Lobby] data class holds the data for the generic information
 * óf a lobby.
 */
data class Lobby(
    val tag: String,
    val name: String,
    val uid: String,
    val username: String,
    val creationTime: Long
)