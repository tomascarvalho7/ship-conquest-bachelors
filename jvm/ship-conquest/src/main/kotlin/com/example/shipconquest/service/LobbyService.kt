package com.example.shipconquest.service

import com.example.shipconquest.domain.Factor
import com.example.shipconquest.domain.Game
import com.example.shipconquest.domain.lobby.Lobby
import com.example.shipconquest.domain.generators.RandomString
import com.example.shipconquest.domain.lobby.toLobbyName
import com.example.shipconquest.domain.world.WorldGenerator
import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.left
import com.example.shipconquest.repo.TransactionManager
import com.example.shipconquest.right
import com.example.shipconquest.service.result.CreateLobbyError
import com.example.shipconquest.service.result.CreateLobbyResult
import com.example.shipconquest.service.result.GetLobbyError
import com.example.shipconquest.service.result.GetLobbyResult
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service

@Service
class LobbyService(
    override val transactionManager: TransactionManager
): ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun createLobby(name: String): CreateLobbyResult {
        val lobbyName = name.toLobbyName() ?: return left(CreateLobbyError.InvalidServerName)
        // generate world
        val generator = WorldGenerator(600)
        val origins = generator.generateIslandCoordinates(Factor(70))
        val world = generator.generate(origins)

        return transactionManager.run { transaction ->
            // generate tag
            val tag = generateTag(transaction.lobbyRepo::get)
            // create lobby & game
            transaction.lobbyRepo.createLobby(lobby = Lobby(tag = tag, name = lobbyName.name))
            transaction.gameRepo.createGame(game = Game(tag = tag, map = world))
            // create island from world map
            for(origin in origins) {
                val island = WildIsland(coordinate = origin, radius = generator.islandSize)
                transaction.islandRepo.create(tag = tag, island = island)
            }
            // return
            right(value = tag)
        }
    }

    fun getLobby(tag: String): GetLobbyResult {
        return transactionManager.run { transaction ->
            val lobby = transaction.lobbyRepo.get(tag)
            // return
            if (lobby != null)      right(lobby)
            else                    left(GetLobbyError.LobbyNotFound)
        }
    }

    private fun generateTag(getLobby: (tag: String) -> Lobby?): String {
        while(true) {
            val tag = RandomString.generate(length = 6)
            if (getLobby(tag) == null) return tag
        }
    }
}