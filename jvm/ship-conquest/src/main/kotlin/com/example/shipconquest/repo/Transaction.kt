package com.example.shipconquest.repo

interface Transaction {
    val gameRepo: GameRepository
    val shipRepo: ShipRepository
    val islandRepo: IslandRepository
    val lobbyRepo: LobbyRepository
    val statsRepo: StatisticsRepository
    val eventRepo: EventRepository
    val userRepo: UserRepository

    // reverse changes made by the current transaction
    fun rollback()
}