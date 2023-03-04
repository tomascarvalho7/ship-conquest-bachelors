package com.example.shipconquest.service

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.Vector3
import com.example.shipconquest.domain.world.pulse
import com.example.shipconquest.left
import com.example.shipconquest.repo.TransactionManager
import com.example.shipconquest.right
import com.example.shipconquest.service.result.GetChunksError
import com.example.shipconquest.service.result.GetChunksResult
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service

const val viewDistance = 10

@Service
class GameService(
    override val transactionManager: TransactionManager
): ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun getChunks(tag: String, x: Int, y: Int): GetChunksResult {
        val position = Position(x = x, y = y)

        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag = tag)
            // return
            if (game != null)   right(game.map.pulse(origin = position, radius = 15))
            else                left(GetChunksError.GameNotFound)
        }
    }
}