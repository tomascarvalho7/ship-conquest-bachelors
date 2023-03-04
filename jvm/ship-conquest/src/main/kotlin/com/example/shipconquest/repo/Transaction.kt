package com.example.shipconquest.repo

interface Transaction {
    val gameRepo: GameRepository
    val lobbyRepo: LobbyRepository

    // reverse changes made by the current transaction
    fun rollback()
}