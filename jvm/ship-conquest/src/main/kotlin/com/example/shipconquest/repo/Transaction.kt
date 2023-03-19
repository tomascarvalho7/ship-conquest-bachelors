package com.example.shipconquest.repo

interface Transaction {
    val gameRepo: GameRepository
    val lobbyRepo: LobbyRepository
    val userRepo: UserRepository

    // reverse changes made by the current transaction
    fun rollback()
}