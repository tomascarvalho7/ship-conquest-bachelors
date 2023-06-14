package com.example.shipconquest.domain.game

import com.example.shipconquest.Clock
import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.logic.EventLogic
import com.example.shipconquest.domain.path_finding.calculateEuclideanDistance
import com.example.shipconquest.domain.ship.movement.Mobile
import com.example.shipconquest.domain.ship.movement.Movement
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.domain.bezier.utils.*
import com.example.shipconquest.domain.event.logic.utils.findIntersectionPoints
import com.example.shipconquest.domain.ship.ShipBuilder
import com.example.shipconquest.domain.ship.ShipInfo
import com.example.shipconquest.domain.ship.build
import com.example.shipconquest.domain.toVector2
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.domain.user.statistics.PlayerStatistics
import com.example.shipconquest.domain.user.statistics.PlayerStatsBuilder
import com.example.shipconquest.domain.user.statistics.build
import com.example.shipconquest.domain.user.statistics.getCurrency
import com.example.shipconquest.domain.world.HeightMap
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.OwnershipDetails
import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.domain.world.pulse
import com.example.shipconquest.repo.Transaction
import com.example.shipconquest.service.buildBeziers
import org.springframework.stereotype.Component
import java.time.Duration
import java.time.Instant
import kotlin.math.roundToLong
import kotlin.random.Random

const val incomePerHour = 25
@Component
class GameLogic(private val clock: Clock) {
    val eventLogic = EventLogic(clock)
    fun getInstant() = clock.now()

    fun getMostRecentMovement(info: ShipInfo): Movement {
        return info.movements.last()
    }

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

    fun getCoordFromMovement(movement: Movement) = when(movement) {
        is Mobile -> movement.getPositionFromInstant(clock.now()).toVector2()
        is Stationary -> movement.position
    }

    fun buildPlayerStatistics(builder: PlayerStatsBuilder) = builder.build(clock.now())

    fun getShipBuilder(tag: String, uid: String, sid: Int, transaction: Transaction): ShipBuilder? {
        val info = transaction.shipRepo.getShipInfo(tag = tag, uid = uid, shipId = sid) ?: return null

        val lastMovement = getMostRecentMovement(info)
        val events = if (lastMovement is Mobile) {
            transaction.eventRepo.getShipEventsAfterInstant(tag = tag, sid = sid, uid = uid, instant = lastMovement.startTime)
        } else emptyList()

        return ShipBuilder(info = info, events = events)
    }

    fun getShipsBuilder(tag: String, uid: String, transaction: Transaction): List<ShipBuilder> {
        val fleetInfo = transaction.shipRepo.getShipsInfo(tag = tag, uid = uid)

        return List(fleetInfo.size) { index ->
            val info = fleetInfo[index]

            val lastMovement = getMostRecentMovement(info)
            val events = if (lastMovement is Mobile) {
                transaction.eventRepo.getShipEventsAfterInstant(tag = tag, sid = info.id, uid = uid, instant = lastMovement.startTime)
            } else emptyList()

            return@List ShipBuilder(info = info, events = events)
        }
    }

    fun getEnemyShipsBuilder(tag: String, uid: String, transaction: Transaction): List<ShipBuilder> {
        val enemyFleetInfo = transaction.shipRepo.getOtherShipsInfo(tag = tag, uid = uid)

        return List(enemyFleetInfo.size) { index ->
            val info = enemyFleetInfo[index]

            val lastMovement = getMostRecentMovement(info)
            val events = if (lastMovement is Mobile) {
                transaction.eventRepo.getShipEventsAfterInstant(
                    tag = tag,
                    uid = uid,
                    sid = info.id,
                    instant = lastMovement.startTime
                )
            } else emptyList()

            return@List ShipBuilder(info = info, events = events)
        }
    }

    fun buildShip(builder: ShipBuilder) = builder.build(clock.now())

    fun buildIslandEvents(
        pathMovement: Mobile,
        islands: List<Island>,
        onIslandEvent: (instant: Instant, island: Island) -> Event
    ): List<Event> {
        return eventLogic.buildIslandEvents(pathMovement, islands, onIslandEvent)
    }

    fun buildFightEvents(
        shipBuilder: ShipBuilder,
        shipBuilders: List<ShipBuilder>,
        onEvent: (instant: Instant, fightDetails: FightEvent) -> Event
    ) = buildList<Event> {
        // TODO: CHANGE
        /*
        // for every ship in movement
        for (ship in shipBuilders) {
            val event = eventLogic.buildFightEventsBetween(current = shipBuilder, enemy = ship, onEvent = onEvent)
            if (event != null) add(event)
        }*/
    }

    fun buildShipMovement(points: List<Vector2>): Mobile {
        var distance = 0.0;
        for (i in 0 until points.size - 1) {
            val a = points[i];
            val b = points[i + 1];
            distance += calculateEuclideanDistance(a, b)
        }
        val duration = Duration.ofSeconds((distance * 2.5).roundToLong()) // was 10 before

        return Mobile(landmarks = buildBeziers(points), startTime = clock.now(), duration = duration)
    }

    fun generateRandomSpawnPoint(world: HeightMap): List<Vector2> {
        while(true) {
            val randomCoord = Vector2(
                x = Random.nextInt(from = 0, until = world.size),
                y = Random.nextInt(from = 0, until = world.size)
            )

            if (world.pulse(origin = randomCoord, radius = 30, water = false).isEmpty())
                return listOf(randomCoord)
        }
    }
}