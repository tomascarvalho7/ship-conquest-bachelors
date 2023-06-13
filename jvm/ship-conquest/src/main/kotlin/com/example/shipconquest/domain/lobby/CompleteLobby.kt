package com.example.shipconquest.domain.lobby

data class CompleteLobby(
    val tag: String,
    val name: String,
    val uid: String,
    val username: String,
    val creationTime: Long,
    val isFavorite: Boolean,
    val playerCount: Int
)
