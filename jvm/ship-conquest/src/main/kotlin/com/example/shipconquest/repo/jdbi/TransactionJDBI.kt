package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.repo.*
import org.jdbi.v3.core.Handle

class TransactionJDBI(private val handle: Handle): Transaction {
    override val gameRepo: GameRepository by lazy { GameRepositoryJDBI(handle = handle) }
    override val islandRepo: IslandRepository by lazy { IslandRepositoryJDBI(handle = handle) }
    override val lobbyRepo: LobbyRepository by lazy { LobbyRepositoryJDBI(handle = handle)}
    override val userRepo: UserRepository by lazy { UserRepositoryJDBI(handle = handle)}

    override fun rollback() {
        handle.rollback()
    }
}