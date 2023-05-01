package com.example.shipconquest.service

import com.example.shipconquest.domain.Factor
import com.example.shipconquest.domain.Game
import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.lobby.Lobby
import com.example.shipconquest.domain.generators.RandomString
import com.example.shipconquest.domain.lobby.toLobbyName
import com.example.shipconquest.domain.user.statistics.PlayerStats
import com.example.shipconquest.domain.world.WorldGenerator
import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.left
import com.example.shipconquest.repo.Transaction
import com.example.shipconquest.repo.TransactionManager
import com.example.shipconquest.right
import com.example.shipconquest.service.result.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service

@Service
class LobbyService(
    override val transactionManager: TransactionManager
) : ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun createLobby(name: String, uid: String): CreateLobbyResult {
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
            for (origin in origins) {
                val island = WildIsland(coordinate = origin, radius = generator.islandSize, islandId = 0) // TODO mudar isto
                transaction.islandRepo.create(tag = tag, island = island)
            }
            // add player to the lobby
            addPlayerToLobby(transaction, tag, uid)
            // return
            right(value = tag)
        }
    }

    fun getLobby(tag: String): GetLobbyResult {
        return transactionManager.run { transaction ->
            val lobby = transaction.lobbyRepo.get(tag)
            // return
            if (lobby != null) right(lobby)
            else left(GetLobbyError.LobbyNotFound)
        }
    }

    fun joinLobby(uid: String, tag: String): JoinLobbyResult {
        return transactionManager.run { transaction ->
            if (transaction.lobbyRepo.get(tag) == null)
                return@run left(JoinLobbyError.LobbyNotFound)

            if (transaction.lobbyRepo.checkUserInLobby(uid, tag))
                return@run right(tag)

            addPlayerToLobby(transaction, tag, uid)
            right(tag)
        }
    }

    fun getAllLobbies(skip: Int, limit: Int): GetAllLobbiesResult {
        if (skip < 0) return left(GetAllLobbiesError.InvalidSkipParameter)
        if (limit < 1) return left(GetAllLobbiesError.InvalidLimitParameter)

        return transactionManager.run { transaction ->
            val lobbies = transaction.lobbyRepo.getAll(skip, limit)
            right(lobbies)
        }
    }

    private fun generateTag(getLobby: (tag: String) -> Lobby?): String {
        while (true) {
            val tag = RandomString.generate(length = 6)
            if (getLobby(tag) == null) return tag
        }
    }

    fun addPlayerToLobby(transaction: Transaction,tag: String, uid: String ) {
        transaction.lobbyRepo.joinLobby(uid, tag)
        transaction.gameRepo.createShipPosition(tag, uid, generateRandomSpawnPoint(), null, null)
        transaction.statsRepo.createPlayerStats(tag, uid, PlayerStats(tag, uid, 0, 3000)) // change this
    }

    private fun generateRandomSpawnPoint() = listOf(Vector2(50, 50)) //TODO generate it randomly
}