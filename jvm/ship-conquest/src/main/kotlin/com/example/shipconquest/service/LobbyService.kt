package com.example.shipconquest.service

import com.example.shipconquest.domain.Factor
import com.example.shipconquest.domain.game.Game
import com.example.shipconquest.domain.game.GameLogic
import com.example.shipconquest.domain.generators.RandomString
import com.example.shipconquest.domain.lobby.*
import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.world.HeightMap
import com.example.shipconquest.domain.world.WorldGenerator
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.domain.world.pulse
import com.example.shipconquest.left
import com.example.shipconquest.repo.Transaction
import com.example.shipconquest.repo.TransactionManager
import com.example.shipconquest.right
import com.example.shipconquest.service.result.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import java.time.Instant
import kotlin.random.Random

@Service
class LobbyService(
    override val transactionManager: TransactionManager,
    val gameLogic: GameLogic // TODO check if this dependency is fine to have
) : ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun createLobby(name: String, uid: String): CreateLobbyResult {
        val lobbyName = name.toLobbyName() ?: return left(CreateLobbyError.InvalidServerName)
        // generate world
        val generator = WorldGenerator(300)
        val origins = generator.generateIslandCoordinates(Factor(70))
        val world = generator.generate(origins)

        return transactionManager.run { transaction ->
            // generate tag
            val tag = generateTag(transaction.lobbyRepo::get)
            // get creator info
            val user = transaction.userRepo.getUserInfo(uid)
            // create lobby & game
            transaction.lobbyRepo.createLobby(
                lobby = Lobby(
                    tag = tag,
                    name = lobbyName.name,
                    uid = uid,
                    username = user!!.username,
                    creationTime = Instant.now().toEpochMilli()
                )
            )
            val game = Game(tag = tag, map = world)
            transaction.gameRepo.createGame(game = game)
            // create island from world map
            for (origin in origins) {
                transaction.islandRepo.create(
                    tag = tag,
                    origin = origin,
                    radius = generator.islandSize
                )
            }
            // add player to the lobby
            addPlayerToLobby(transaction, game, tag, uid)
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
            val game = transaction.gameRepo.get(tag = tag)
                ?: return@run left(JoinLobbyError.LobbyNotFound)

            if (transaction.lobbyRepo.checkUserInLobby(uid, tag))
                return@run right(tag)

            addPlayerToLobby(transaction, game, tag, uid)
            right(tag)
        }
    }

    fun getLobbies(skip: Int?, limit: Int?, order: String?, name: String?): GetAllLobbiesResult {
        val newSkip = skip.toSkip()
        val newLimit = limit.toLimit()
        val newOrder = order.toOrderOrNull() ?: return left(GetAllLobbiesError.InvalidOrderParameter)

        return transactionManager.run { transaction ->

            val lobbies = if(name?.isEmpty() == true || name == null) {
                transaction.lobbyRepo.getList(newSkip, newLimit, newOrder)
            } else {
                transaction.lobbyRepo.getListByName(newSkip, newLimit, newOrder, name)
            }
            right(lobbies)
        }
    }

    private fun generateTag(getLobby: (tag: String) -> Lobby?): String {
        while (true) {
            val tag = RandomString.generate(length = 6)
            if (getLobby(tag) == null) return tag
        }
    }

    fun addPlayerToLobby(transaction: Transaction, game: Game, tag: String, uid: String) {
        transaction.lobbyRepo.joinLobby(uid = uid, tag = tag)
        transaction.shipRepo.createShipInfo(tag, uid, gameLogic.generateRandomSpawnPoint(game.map), null, null)
        transaction.statsRepo.createPlayerStats(tag = tag, uid = uid, initialCurrency = 125)
    }


}