package com.example.shipconquest.repo

import com.example.shipconquest.domain.Game
import org.slf4j.Logger

interface GameRepository {
    val logger: Logger
    fun get(tag: String): Game?
    fun createGame(game: Game)
}