package com.example.shipconquest.domain.game.logic

import com.example.shipconquest.Clock
import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.logic.EventLogic
import com.example.shipconquest.domain.path_finding.calculateEuclideanDistance
import com.example.shipconquest.domain.ship.movement.Kinetic
import com.example.shipconquest.domain.ship.movement.Movement
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.domain.ship.ShipBuilder
import com.example.shipconquest.domain.ship.ShipInfo
import com.example.shipconquest.domain.toVector2
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.domain.user.statistics.PlayerStatsBuilder
import com.example.shipconquest.domain.user.statistics.build
import com.example.shipconquest.domain.user.statistics.getCurrency
import com.example.shipconquest.domain.world.HeightMap
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.OwnershipDetails
import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.domain.world.pulse
import com.example.shipconquest.service.buildSpline
import org.springframework.stereotype.Component
import java.time.Duration
import java.time.Instant
import kotlin.math.roundToLong
import kotlin.random.Random

const val incomePerHour = 25

/**
 * The [GameLogic] class handles all game-related logic, including:
 * - Making transactions to the player's currency;
 * - Building the player's statistics at the current [Instant];
 * - Building the movement of a ship at the current [Instant];
 * - Player and Island interactions;
 * - Generating a random spawn point in the world;
 * - All the [EventLogic] class logic.
 *
 * This class is aware of the concept of time through the [clock] value.
 */
@Component
class GameLogic(private val clock: Clock) {
    val eventLogic = EventLogic(clock)

    // get current instant
    fun getInstant() = clock.now()

    // get the last movement made by a ship
    fun getMostRecentMovement(info: ShipInfo): Movement {
        return info.movements.last()
    }

    // make (if possible) a transaction to the current player's currency
    fun makeTransaction(
        statistics: PlayerStatsBuilder,
        transaction: Int,
        onSuccess: (newCurrency: Int, instant: Instant) -> Unit
    ): Int? {
        val instant = clock.now()
        val currency = statistics.income.getCurrency(now = instant)
        val newCurrency = if (currency > transaction) currency - transaction else null

        if (newCurrency != null) onSuccess(newCurrency, instant)
        return newCurrency
    }

    // conquest (if possible) an island
    fun conquestIsland(
        user: User,
        island: Island,
        onWild: (old: WildIsland, new: OwnedIsland) -> Unit,
        onOwned: (old: OwnedIsland, new: OwnedIsland) -> Unit
    ): OwnedIsland? {
        if (island is OwnedIsland && island.uid == user.id) return null;
        val newIsland = OwnedIsland(
            islandId = island.islandId,
            coordinate = island.coordinate,
            radius = island.radius,
            incomePerHour = incomePerHour,
            conquestDate = clock.now(),
            uid = user.id,
            ownershipDetails = OwnershipDetails(owned = true, username = user.name)
        )

        when(island) {
            is WildIsland -> onWild(island, newIsland)
            is OwnedIsland -> onOwned(island, newIsland)
        }
        return newIsland
    }

    // get X and Y axis coordinate from a ship movement at the current [Instant]
    fun getCoordFromMovement(movement: Movement) = when(movement) {
        is Kinetic -> movement.getPositionFromInstant(clock.now()).toVector2()
        is Stationary -> movement.position
    }

    // build the player's statistics at the current [Instant]
    fun buildPlayerStatistics(builder: PlayerStatsBuilder) = builder.build(clock.now())

    // get an [ShipBuilder] from the ship's movements and events
    fun getShipBuilder(
        tag: String,
        uid: String,
        sid: Int,
        getShipInfo: (tag: String, sid: Int, uid: String) -> ShipInfo?,
        getEventsAfterInstant: (tag: String, uid: String, sid: Int, instant: Instant) -> List<Event>
    ): ShipBuilder? {
        val info = getShipInfo(tag, sid, uid) ?: return null

        val lastMovement = getMostRecentMovement(info)
        val events = if (lastMovement is Kinetic) {
            getEventsAfterInstant(tag, uid, sid, lastMovement.startTime)
        } else emptyList()

        return ShipBuilder(info = info, events = events)
    }

    // get all [ShipBuilder] from the player's fleet
    fun getFleetBuilder(
        tag: String,
        uid: String,
        getFleet: (tag: String, uid: String) -> List<ShipInfo>,
        getEventsAfterInstant: (tag: String, uid: String, sid: Int, instant: Instant) -> List<Event>
        ): List<ShipBuilder> {
        val fleetInfo = getFleet(tag, uid)

        return List(fleetInfo.size) { index ->
            val info = fleetInfo[index]

            val lastMovement = getMostRecentMovement(info)
            val events = if (lastMovement is Kinetic) {
                getEventsAfterInstant(tag, uid, info.id, lastMovement.startTime)
            } else emptyList()

            return@List ShipBuilder(info = info, events = events)
        }
    }

    // build a static [Ship] from an [ShipBuilder]
    fun buildShip(builder: ShipBuilder) = builder.build(clock.now())

    // build island events between a ship and a group of islands
    fun buildIslandEvents(
        pathMovement: Kinetic,
        islands: List<Island>,
        onIslandEvent: (instant: Instant, island: Island) -> Event
    ): List<Event> {
        return eventLogic.buildIslandEvents(pathMovement, islands, onIslandEvent)
    }

    // build fight events between ships
    fun buildFightEvents(
        shipBuilder: ShipBuilder,
        shipBuilders: List<ShipBuilder>,
        onEvent: (instant: Instant, fightDetails: FightEvent) -> Event
    ) = buildList<Event> {
        // for every ship in movement
        for (ship in shipBuilders) {
            val event = eventLogic.buildFightEventsBetweenShips(current = shipBuilder, enemy = ship, onEvent = onEvent)
            if (event != null) add(event)
        }
    }

    // build ship movement from list of points
    fun buildMovementFromPoints(points: List<Vector2>): Kinetic? {
        var distance = 0.0;
        for (i in 0 until points.size - 1) {
            val a = points[i];
            val b = points[i + 1];
            distance += calculateEuclideanDistance(a, b)
        }
        val duration = Duration.ofSeconds((distance * 2.5).roundToLong()) // was 10 before

        val spline = buildSpline(points) ?: return null
        return Kinetic(spline = spline, startTime = clock.now(), duration = duration)
    }

    // generate a random point and search for a [Vector2] coordinate that is free
    // in a radius of 15x15
    fun generateRandomSpawnPoint(world: HeightMap): List<Vector2> {
        while(true) {
            val randomCoord = Vector2(
                x = Random.nextInt(from = 0, until = world.size),
                y = Random.nextInt(from = 0, until = world.size)
            )

            if (world.pulse(origin = randomCoord, radius = 15, water = false).isEmpty())
                return listOf(randomCoord)
        }
    }

    fun trimMovements(movements: List<Kinetic>) = buildList {
        val instant = clock.now()
        for (index in 0 until movements.size - 1) {
            val first = movements[index]
            val second = movements[index + 1]

            addAll(first.shorten(instant = second.startTime).getPoints())
        }
        addAll(movements.last().shorten(instant).getPoints())
    }
}