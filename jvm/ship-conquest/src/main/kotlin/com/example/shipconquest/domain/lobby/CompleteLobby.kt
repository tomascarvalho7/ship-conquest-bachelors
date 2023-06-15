package com.example.shipconquest.domain.lobby

/**
 * The [CompleteLobby] data class holds the data for the complete set of
 * information available for a lobby.
 */
data class CompleteLobby(
    val tag: String,
    val name: String,
    val uid: String,
    val username: String,
    val creationTime: Long,
    val isFavorite: Boolean,
    val playerCount: Int
)
