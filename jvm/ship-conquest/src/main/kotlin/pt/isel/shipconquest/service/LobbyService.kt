package pt.isel.shipconquest.service

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import pt.isel.shipconquest.domain.Factor
import pt.isel.shipconquest.domain.game.Game
import pt.isel.shipconquest.domain.game.logic.GameLogic
import pt.isel.shipconquest.domain.generators.RandomString
import pt.isel.shipconquest.domain.lobby.*
import pt.isel.shipconquest.domain.world.WorldGenerator
import pt.isel.shipconquest.repo.Transaction
import pt.isel.shipconquest.repo.TransactionManager
import pt.isel.shipconquest.service.result.*
import java.time.Instant

@Service
class LobbyService(
    override val transactionManager: TransactionManager,
    val gameLogic: GameLogic
) : ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun createLobby(name: String, uid: String): CreateLobbyResult {
        val lobbyName = name.toLobbyName() ?: return pt.isel.shipconquest.left(CreateLobbyError.InvalidServerName)
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
            pt.isel.shipconquest.right(value = tag)
        }
    }

    fun getLobby(tag: String): GetLobbyResult {
        return transactionManager.run { transaction ->
            val lobby = transaction.lobbyRepo.get(tag)
            // return
            if (lobby != null) pt.isel.shipconquest.right(lobby)
            else pt.isel.shipconquest.left(GetLobbyError.LobbyNotFound)
        }
    }

    fun joinLobby(uid: String, tag: String): JoinLobbyResult {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag = tag)
                ?: return@run pt.isel.shipconquest.left(JoinLobbyError.LobbyNotFound)

            if (transaction.lobbyRepo.checkUserInLobby(uid, tag))
                return@run pt.isel.shipconquest.right(tag)

            addPlayerToLobby(transaction, game, tag, uid)
            pt.isel.shipconquest.right(tag)
        }
    }

    fun getLobbies(uid: String, skip: Int?, limit: Int?, order: String?, name: String?): GetAllLobbiesResult {
        val newSkip = skip.toSkip()
        val newLimit = limit.toLimit()
        val newOrder = order.toOrderOrNull() ?: return pt.isel.shipconquest.left(GetLobbyListError.InvalidOrderParameter)

        return transactionManager.run { transaction ->
            val lobbies = if(name.isNullOrEmpty()) {
                    transaction.lobbyRepo.getList(uid, newSkip, newLimit, newOrder)
            } else {
                    transaction.lobbyRepo.getListByName(uid, newSkip, newLimit, newOrder, name)
            }
            pt.isel.shipconquest.right(lobbies)
        }
    }

    fun getFavoriteLobbies(uid: String, skip: Int?, limit: Int?, order: String?, name: String?): GetAllLobbiesResult {
        val newSkip = skip.toSkip()
        val newLimit = limit.toLimit()
        val newOrder = order.toOrderOrNull() ?: return pt.isel.shipconquest.left(GetLobbyListError.InvalidOrderParameter)

        return transactionManager.run { transaction ->
            val lobbies = if(name.isNullOrEmpty()) {
                    transaction.lobbyRepo.getFavoriteList(uid, newSkip, newLimit, newOrder)
            } else {
                    transaction.lobbyRepo.getFavoriteListByName(uid, newSkip, newLimit, newOrder, name)
            }
            pt.isel.shipconquest.right(lobbies)
        }
    }

    fun getRecentLobbies(uid: String, skip: Int?, limit: Int?, order: String?, name: String?): GetAllLobbiesResult {
        val newSkip = skip.toSkip()
        val newLimit = limit.toLimit()
        val newOrder = order.toOrderOrNull() ?: return pt.isel.shipconquest.left(GetLobbyListError.InvalidOrderParameter)

        return transactionManager.run { transaction ->
            val lobbies = if(name.isNullOrEmpty()) {
                    transaction.lobbyRepo.getRecentList(uid, newSkip, newLimit, newOrder)
            } else {
                    transaction.lobbyRepo.getRecentListByName(uid, newSkip, newLimit, newOrder, name)
            }
            pt.isel.shipconquest.right(lobbies)
        }
    }

    fun setFavoriteLobby(uid: String, tag: String): FavoriteOperationResult {
        return transactionManager.run { transaction ->
            transaction.lobbyRepo.get(tag) ?: return@run pt.isel.shipconquest.left(SetFavoriteError.LobbyNotFound)
            transaction.lobbyRepo.setFavorite(uid, tag)

            pt.isel.shipconquest.right(true)
        }
    }

    fun removeFavoriteLobby(uid: String, tag: String): FavoriteOperationResult {
        return transactionManager.run { transaction ->
            transaction.lobbyRepo.get(tag) ?: return@run pt.isel.shipconquest.left(SetFavoriteError.LobbyNotFound)
            transaction.lobbyRepo.removeFavorite(uid, tag)

            pt.isel.shipconquest.right(false)
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