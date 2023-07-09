package pt.isel.shipconquest.service

import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.game.Game
import com.example.shipconquest.domain.game.logic.GameLogic
import com.example.shipconquest.domain.minimap.Minimap
import com.example.shipconquest.domain.path_builder.PathPoints
import com.example.shipconquest.domain.ship.*
import com.example.shipconquest.domain.ship.movement.Kinetic
import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.domain.user.statistics.getCurrency
import com.example.shipconquest.domain.world.Horizon
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.IslandList
import com.example.shipconquest.domain.world.islands.getCost
import com.example.shipconquest.domain.world.islands.getNearIslands
import com.example.shipconquest.domain.world.islandsToHeightMap
import com.example.shipconquest.domain.world.pulse
import pt.isel.shipconquest.left
import com.example.shipconquest.repo.TransactionManager
import pt.isel.shipconquest.right
import com.example.shipconquest.service.result.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import kotlin.math.roundToInt

const val viewDistance = 15
const val shipCost = 50

@Service
class GameService(
    override val transactionManager: TransactionManager,
    val gameLogic: GameLogic
) : ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun getChunks(tag: String, shipId: Int, uid: String): GetChunksResult {
        return transactionManager.run { transaction ->
            val shipBuilder = gameLogic.getShipBuilder(
                tag = tag,
                uid = uid,
                sid = shipId,
                getShipInfo = transaction.shipRepo::getShipInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant
            ) ?: return@run pt.isel.shipconquest.left(GetChunksError.ShipPositionNotFound)
            val coord = gameLogic.getCoordFromMovement(gameLogic.buildShip(shipBuilder).movement)

            val game = transaction.gameRepo.get(tag = tag)
            if (game != null) {
                val islands = transaction.islandRepo.getVisitedIslands(tag = tag, uid = uid)
                val nearIslands = getNearIslands(coordinate = coord, islands = islands)
                pt.isel.shipconquest.right(
                    value = Horizon(
                        voxels = game.inspectIslands(nearIslands),
                        islands = nearIslands
                    )
                )
            } else pt.isel.shipconquest.left(GetChunksError.GameNotFound)
        }
    }

    fun Game.inspectIslands(nearIslands: List<Island>) = buildList {
        for (island in nearIslands)
            addAll(
                map.pulse(
                    origin = island.coordinate,
                    radius = (island.radius / 1.8).roundToInt(),
                    water = true
                )
            )
    }

    fun getPlayerStats(tag: String, uid: String): GetPlayerStatsResult {
        return transactionManager.run { transaction ->
            val lobby = transaction.lobbyRepo.get(tag = tag) ?: return@run pt.isel.shipconquest.left(GetPlayerStatsError.GameNotFound)
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = uid)
                ?: return@run pt.isel.shipconquest.left(GetPlayerStatsError.StatisticsNotFound)

            return@run pt.isel.shipconquest.right(value = gameLogic.buildPlayerStatistics(playerStatistics))
        }
    }

    fun getMinimap(tag: String, uid: String): GetMinimapResult {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag) ?: return@run pt.isel.shipconquest.left(GetMinimapError.GameNotFound)
            // get user ships
            val userShips = transaction.shipRepo.getShipsInfo(tag, uid)
            val currInstant = gameLogic.getInstant()

            val pathPoints = mutableListOf<Vector2>()
            // iterate in users ships
            for (ship in userShips) {
                // get ship path
                val events = transaction.eventRepo.getShipEvents(tag = tag, uid = uid, sid = ship.id)
                val builtMovements = ship.movements
                    .map { buildMovementFromEvents(it, currInstant, events) }
                    .filterIsInstance<Kinetic>()
                // add trimmed movements to list of control points
                if (builtMovements.isNotEmpty())
                    pathPoints.addAll(gameLogic.trimMovements(builtMovements))
            }

            // get visited islands
            val visitedIslands = transaction.islandRepo.getVisitedIslands(tag = tag, uid = uid)

            // get the voxels around the island's origins
            val islands = visitedIslands.flatMap { island ->
                game.map.pulse(origin = island.coordinate, radius = viewDistance, water = true)
            }.distinct()

            pt.isel.shipconquest.right(value = Minimap(paths = pathPoints, islands = islands, size = game.map.size))
        }
    }

    fun getKnownIslands(tag: String, uid: String): GetKnownIslandsResult {
        return transactionManager.run { transaction ->
            transaction.gameRepo.get(tag) ?: return@run pt.isel.shipconquest.left(GetKnownIslandsError.GameNotFound)

            pt.isel.shipconquest.right(
                value = IslandList(
                    islands = transaction.islandRepo.getVisitedIslands(tag = tag, uid = uid)
                )
            )
        }
    }

    fun navigate(tag: String, uid: String, shipId: Int, points: PathPoints): NavigationResult {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag = tag) ?:
                return@run pt.isel.shipconquest.left(NavigationError.GameNotFound)
            val visitedIslands = transaction.islandRepo.getVisitedIslands(tag = tag, uid = uid)
            // build a heightmap from only the visited islands
            val map = islandsToHeightMap(
                islands = visitedIslands.flatMap { island ->
                    game.map.pulse(origin = island.coordinate, radius = viewDistance, water = false)
                }.distinct(),
                size = game.map.size
            )
            // build a kinetic movement from path points
            val movement = gameLogic.buildMovementFromPoints(points, map) ?:
                return@run pt.isel.shipconquest.left(NavigationError.InvalidNavigationPath)

            val shipInfo = transaction.shipRepo.getShipInfo(tag = tag, shipId =  shipId, uid = uid)
                ?.addMovement(movement) ?: return@run pt.isel.shipconquest.left(NavigationError.ShipNotFound)
            // delete future events since ship path has changed
            transaction.eventRepo.deleteShipEventsAfterInstant(tag = tag, sid = shipId, instant = movement.startTime)
            transaction.shipRepo.updateShipInfo(
                tag,
                uid,
                shipId,
                movement
            )

            // get all islands
            val islands = transaction.islandRepo.getUnvisitedIslands(tag = tag, uid = uid)
            val islandEvents = gameLogic.buildIslandEvents(movement, islands) { instant, island ->
                transaction.eventRepo.createIslandEvent(tag, instant, IslandEvent(shipId, island))
            }
            val shipBuilder = ShipBuilder(info = shipInfo, events = islandEvents)
            val fleetBuilder = gameLogic.getFleetBuilder(
                tag = tag,
                uid = uid,
                getFleet = transaction.shipRepo::getOtherShipsInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant
            )
            val fightEvents = gameLogic.buildFightEvents(shipBuilder, fleetBuilder) { instant, details ->
                transaction.eventRepo.createFightingEvent(tag, instant, details)
            }
            pt.isel.shipconquest.right(gameLogic.buildShip(shipBuilder.addEvents(newEvents = fightEvents)))
        }
    }

    fun getShip(tag: String, uid: String, shipId: Int): GetShipResult {
        return transactionManager.run { transaction ->
            // check if game exists
            transaction.gameRepo.get(tag = tag) ?: return@run pt.isel.shipconquest.left(GetShipError.GameNotFound)
            val builder = gameLogic.getShipBuilder(
                tag = tag,
                uid = uid,
                sid = shipId,
                getShipInfo = transaction.shipRepo::getShipInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant
            ) ?: return@run pt.isel.shipconquest.left(GetShipError.ShipNotFound)

            return@run pt.isel.shipconquest.right(
                value = gameLogic.buildShip(builder = builder)
            )
        }
    }

    fun getShips(tag: String, uid: String): GetShipsResult {
        return transactionManager.run { transaction ->
            // check if game exists
            transaction.gameRepo.get(tag = tag) ?: return@run pt.isel.shipconquest.left(GetShipsError.GameNotFound)
            val fleetBuilder = gameLogic.getFleetBuilder(
                tag = tag,
                uid = uid,
                getFleet = transaction.shipRepo::getShipsInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant

            )

            return@run pt.isel.shipconquest.right(
                value = Fleet(
                    ships = fleetBuilder.map { builder -> gameLogic.buildShip(builder = builder) }
                )
            )
        }
    }

    fun addShip(tag: String, uid: String): CreateShipResult {
        return transactionManager.run { transaction ->
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = uid)
                ?: return@run pt.isel.shipconquest.left(CreateShipError.PlayerStatisticsNotFound)
            val game = transaction.gameRepo.get(tag) ?: return@run pt.isel.shipconquest.left(CreateShipError.GameNotFound)

            val canBuy = gameLogic.makeTransaction(playerStatistics, shipCost) { newCurrency, instant ->
                transaction.statsRepo.updatePlayerCurrency(
                    tag = tag,
                    uid = uid,
                    instant = instant,
                    newStaticCurrency = newCurrency
                )
            }

            return@run if(canBuy != null) {
                val newShip = transaction.shipRepo.createShipInfo(tag, uid, gameLogic.generateRandomSpawnPoint(game.map), null, null)

                pt.isel.shipconquest.right(gameLogic.buildShip(ShipBuilder(newShip, emptyList())))
            } else {
                pt.isel.shipconquest.left(CreateShipError.NotEnoughCurrency)
            }
        }
    }

    fun conquestIsland(tag: String, user: User, shipId: String, islandId: Int): ConquestIslandResult {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag = tag)
                ?: return@run pt.isel.shipconquest.left(ConquestIslandError.GameNotFound)
            val island = transaction.islandRepo.get(tag = tag, uid = user.id, islandId = islandId)
                ?: return@run pt.isel.shipconquest.left(ConquestIslandError.IslandNotFound)
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = user.id)
                ?: return@run pt.isel.shipconquest.left(ConquestIslandError.PlayerStatisticsNotFound)
            // TODO: update with canSightIsland
            if (false) return@run pt.isel.shipconquest.left(ConquestIslandError.ShipTooFarAway)

            // make currency transaction
            gameLogic.makeTransaction(playerStatistics, island.getCost()) { newCurrency, instant ->
                transaction.statsRepo.updatePlayerCurrency(
                    tag = tag,
                    uid = user.id,
                    instant = instant,
                    newStaticCurrency = newCurrency
                )
            } ?: return@run pt.isel.shipconquest.left(ConquestIslandError.NotEnoughCurrency)

            val newIsland = gameLogic.conquestIsland(
                user = user,
                island = island,
                onWild = { _, newIsland ->
                    // add ownership of island and take cost from currency
                    transaction.islandRepo.wildToOwnedIsland(tag = tag, island = newIsland)
                },
                onOwned = { oldIsland, newIsland ->
                    // update previous owner of island currency
                    val oldOwner = transaction.statsRepo.getPlayerStats(tag = tag, uid = oldIsland.uid)
                    if (oldOwner != null)
                        transaction.statsRepo.updatePlayerCurrency(
                            tag = tag,
                            uid = oldOwner.uid,
                            instant = newIsland.conquestDate,
                            newStaticCurrency = oldOwner.income.getCurrency(newIsland.conquestDate)
                        )

                    // add ownership of island and take cost from currency
                    transaction.islandRepo.updateOwnedIsland(tag = tag, island = newIsland)
                }
            ) ?: return@run pt.isel.shipconquest.left(ConquestIslandError.AlreadyOwnedIsland)

            return@run pt.isel.shipconquest.right(
                value = newIsland
            )
        }
    }
}