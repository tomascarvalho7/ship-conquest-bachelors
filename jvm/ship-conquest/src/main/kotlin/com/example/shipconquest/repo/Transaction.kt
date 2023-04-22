package com.example.shipconquest.repo

interface Transaction {
    val gameRepo: GameRepository
    val islandRepo: IslandRepository
    val lobbyRepo: LobbyRepository
    val userRepo: UserRepository

    // reverse changes made by the current transaction
    fun rollback()
}