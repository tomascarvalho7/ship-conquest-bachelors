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
import com.example.shipconquest.domain.user.statistics.PlayerStatsBuilder
import com.example.shipconquest.domain.user.statistics.build
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.repo.Transaction
import com.example.shipconquest.service.buildBeziers
import org.springframework.stereotype.Component
import java.time.Duration
import java.time.Instant
import kotlin.math.roundToLong

const val incomePerHour = 25
@Component
class GameLogic(private val clock: Clock) {
    val eventLogic = EventLogic(clock)
    fun getInstant() = clock.now()

    fun getMostRecentMovement(info: ShipInfo): Movement {
        return info.movements.last()
    }

    fun conquestIsland(
        uid: String,
        island: Island,
        onWild: (old: WildIsland, new: OwnedIsland) -> Unit,
        onOwned: (old: OwnedIsland, new: OwnedIsland) -> Unit
    ): OwnedIsland? {
        if (island is OwnedIsland && island.uid == uid) return null;
        val newIsland = OwnedIsland(
            islandId = island.islandId,
            coordinate = island.coordinate,
            radius = island.radius,
            incomePerHour = incomePerHour,
            conquestDate = clock.now(),
            uid = uid
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
            transaction.eventRepo.getShipEventsAfterInstant(tag = tag, sid = sid, instant = lastMovement.startTime)
        } else emptyList()

        return ShipBuilder(info = info, events = events)
    }

    fun getShipsBuilder(tag: String, uid: String, transaction: Transaction): List<ShipBuilder> {
        val fleetInfo = transaction.shipRepo.getShipsInfo(tag = tag, uid = uid)

        return List(fleetInfo.size) { index ->
            val info = fleetInfo[index]

            val lastMovement = getMostRecentMovement(info)
            val events = if (lastMovement is Mobile) {
                transaction.eventRepo.getShipEventsAfterInstant(tag = tag, sid = info.id, instant = lastMovement.startTime)
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
        val intersection = findIntersectionPoints(pathMovement.getUniquePoints(), islands) ?: return emptyList()
        val u = findNearestU(intersection, pathMovement)
        return listOf(onIslandEvent(pathMovement.getInstant(u), intersection.island))
    }

    fun buildFightEvents(
        shipBuilder: ShipBuilder,
        shipBuilders: List<ShipBuilder>,
        onEvent: (instant: Instant, fightDetails: FightEvent) -> Event
    ) = buildList {
        // for every ship in movement
        for (ship in shipBuilders) {
            val event = eventLogic.buildFightEventsBetween(current = shipBuilder, enemy = ship, onEvent = onEvent)
            if (event != null) add(event)
        }
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
}