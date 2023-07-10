package pt.isel.shipconquest.service

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import pt.isel.shipconquest.Either
import pt.isel.shipconquest.domain.event.event_details.IslandEvent
import pt.isel.shipconquest.domain.game.Game
import pt.isel.shipconquest.domain.game.logic.GameLogic
import pt.isel.shipconquest.domain.minimap.Minimap
import pt.isel.shipconquest.domain.path_builder.PathPoints
import pt.isel.shipconquest.domain.ship.Fleet
import pt.isel.shipconquest.domain.ship.ShipBuilder
import pt.isel.shipconquest.domain.ship.addMovement
import pt.isel.shipconquest.domain.ship.buildMovementFromEvents
import pt.isel.shipconquest.domain.ship.movement.Kinetic
import pt.isel.shipconquest.domain.space.Vector2
import pt.isel.shipconquest.domain.user.User
import pt.isel.shipconquest.domain.user.statistics.getCurrency
import pt.isel.shipconquest.domain.world.Horizon
import pt.isel.shipconquest.domain.world.islands.*
import pt.isel.shipconquest.domain.world.islandsToHeightMap
import pt.isel.shipconquest.domain.world.pulse
import pt.isel.shipconquest.left
import pt.isel.shipconquest.repo.TransactionManager
import pt.isel.shipconquest.right
import pt.isel.shipconquest.service.result.*
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
            ) ?: return@run left(GetChunksError.ShipPositionNotFound)
            val coord = gameLogic.getCoordFromMovement(gameLogic.buildShip(shipBuilder).movement)

            val game = transaction.gameRepo.get(tag = tag)
            if (game != null) {
                val islands = transaction.islandRepo.getVisitedIslandsBeforeInstant(tag = tag, uid = uid, instant = gameLogic.getInstant())
                val nearIslands = getNearIslands(coordinate = coord, islands = islands)
                right(
                    value = Horizon(
                        voxels = game.inspectIslands(nearIslands),
                        islands = nearIslands
                    )
                )
            } else left(GetChunksError.GameNotFound)
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
            transaction.lobbyRepo.get(tag = tag) ?: return@run pt.isel.shipconquest.left(GetPlayerStatsError.GameNotFound)
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = uid)
                ?: return@run left(GetPlayerStatsError.StatisticsNotFound)

            return@run right(value = gameLogic.buildPlayerStatistics(playerStatistics))
        }
    }

    fun getMinimap(tag: String, uid: String): GetMinimapResult {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag) ?: return@run left(GetMinimapError.GameNotFound)
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
            val visitedIslands = transaction.islandRepo.getVisitedIslandsBeforeInstant(tag = tag, uid = uid, instant = gameLogic.getInstant())

            // get the voxels around the island's origins
            val islands = visitedIslands.flatMap { island ->
                game.map.pulse(origin = island.coordinate, radius = viewDistance, water = true)
            }.distinct()

            right(value = Minimap(paths = pathPoints, islands = islands, size = game.map.size))
        }
    }

    fun getKnownIslands(tag: String, uid: String): GetKnownIslandsResult {
        return transactionManager.run { transaction ->
            transaction.gameRepo.get(tag) ?: return@run left(GetKnownIslandsError.GameNotFound)

            right(
                value = IslandList(
                    islands = transaction.islandRepo.getVisitedIslands(tag = tag, uid = uid)
                )
            )
        }
    }

    fun navigate(tag: String, uid: String, shipId: Int, points: PathPoints): NavigationResult {
        return transactionManager.run { transaction ->
            val game = transaction.gameRepo.get(tag = tag) ?:
                return@run left(NavigationError.GameNotFound)
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
                return@run left(NavigationError.InvalidNavigationPath)

            val shipInfo = transaction.shipRepo.getShipInfo(tag = tag, shipId =  shipId, uid = uid)
                ?.addMovement(movement) ?: return@run left(NavigationError.ShipNotFound)
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
            right(gameLogic.buildShip(shipBuilder.addEvents(newEvents = fightEvents)))
        }
    }

    fun getShip(tag: String, uid: String, shipId: Int): GetShipResult {
        return transactionManager.run { transaction ->
            // check if game exists
            transaction.gameRepo.get(tag = tag) ?: return@run left(GetShipError.GameNotFound)
            val builder = gameLogic.getShipBuilder(
                tag = tag,
                uid = uid,
                sid = shipId,
                getShipInfo = transaction.shipRepo::getShipInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant
            ) ?: return@run left(GetShipError.ShipNotFound)

            return@run right(
                value = gameLogic.buildShip(builder = builder)
            )
        }
    }

    fun getShips(tag: String, uid: String): GetShipsResult {
        return transactionManager.run { transaction ->
            // check if game exists
            transaction.gameRepo.get(tag = tag) ?: return@run left(GetShipsError.GameNotFound)
            val fleetBuilder = gameLogic.getFleetBuilder(
                tag = tag,
                uid = uid,
                getFleet = transaction.shipRepo::getShipsInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant

            )

            return@run right(
                value = Fleet(
                    ships = fleetBuilder.map { builder -> gameLogic.buildShip(builder = builder) }
                )
            )
        }
    }

    fun addShip(tag: String, uid: String): CreateShipResult {
        return transactionManager.run { transaction ->
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = uid)
                ?: return@run left(CreateShipError.PlayerStatisticsNotFound)
            val game = transaction.gameRepo.get(tag) ?: return@run left(CreateShipError.GameNotFound)

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

                right(gameLogic.buildShip(ShipBuilder(newShip, emptyList())))
            } else {
                left(CreateShipError.NotEnoughCurrency)
            }
        }
    }

    fun conquestIsland(tag: String, user: User, shipId: Int, islandId: Int): ConquestIslandResult {
        return transactionManager.run { transaction ->
            transaction.gameRepo.get(tag = tag)
                ?: return@run left(ConquestIslandError.GameNotFound)
            val island = transaction.islandRepo.get(tag = tag, uid = user.id, islandId = islandId)
                ?: return@run left(ConquestIslandError.IslandNotFound)
            val playerStatistics = transaction.statsRepo.getPlayerStats(tag = tag, uid = user.id)
                ?: return@run left(ConquestIslandError.PlayerStatisticsNotFound)
            val shipBuilder = gameLogic.getShipBuilder(
                tag = tag,
                uid = user.id,
                sid = shipId,
                getShipInfo = transaction.shipRepo::getShipInfo,
                getEventsAfterInstant = transaction.eventRepo::getShipEventsAfterInstant
            ) ?: return@run left(ConquestIslandError.ShipNotFound)
            val coord = gameLogic.getCoordFromMovement(gameLogic.buildShip(shipBuilder).movement)
            if (!canSightIsland(coord, island)) return@run left(ConquestIslandError.ShipTooFarAway)

            // make currency transaction
            gameLogic.makeTransaction(playerStatistics, island.getCost()) { newCurrency, instant ->
                transaction.statsRepo.updatePlayerCurrency(
                    tag = tag,
                    uid = user.id,
                    instant = instant,
                    newStaticCurrency = newCurrency
                )
            } ?: return@run left(ConquestIslandError.NotEnoughCurrency)

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
            ) ?: return@run left(ConquestIslandError.AlreadyOwnedIsland)

            return@run right(
                value = newIsland
            )
        }
    }
}