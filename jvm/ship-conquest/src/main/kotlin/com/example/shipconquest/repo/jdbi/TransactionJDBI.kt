package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.repo.GameRepository
import com.example.shipconquest.repo.LobbyRepository
import com.example.shipconquest.repo.Transaction
import com.example.shipconquest.repo.UserRepository
import org.jdbi.v3.core.Handle

class TransactionJDBI(private val handle: Handle): Transaction {
    override val gameRepo: GameRepository by lazy { GameRepositoryJDBI(handle = handle) }
    override val lobbyRepo: LobbyRepository by lazy { LobbyRepositoryJDBI(handle = handle)}
    override val userRepo: UserRepository by lazy { UserRepositoryJDBI(handle = handle)}

    override fun rollback() {
        handle.rollback()
    }
}