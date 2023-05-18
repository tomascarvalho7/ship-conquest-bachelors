package com.example.shipconquest.domain.game

import com.example.shipconquest.Clock
import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.path_finding.calculateEuclideanDistance
import com.example.shipconquest.domain.ship_navigation.utils.comparePoints
import com.example.shipconquest.domain.ship_navigation.utils.findIntersectionPoints
import com.example.shipconquest.domain.ship_navigation.ship.ShipBuilder
import com.example.shipconquest.domain.ship_navigation.ship.ShipInfo
import com.example.shipconquest.domain.ship_navigation.ship.build
import com.example.shipconquest.domain.ship_navigation.ship.movement.Mobile
import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement
import com.example.shipconquest.domain.ship_navigation.ship.movement.Stationary
import com.example.shipconquest.domain.ship_navigation.utils.*
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
    fun getInstant() = clock.now()
    fun conquestIsland(
        uid: String,
        island: Island,
        onWild: (old: WildIsland, new: OwnedIsland) -> Unit,
        onOwned: (old: OwnedIsland, new: OwnedIsland) -> Unit
    ): OwnedIsland {
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

    fun getMostRecentMovement(info: ShipInfo): Movement {
        return info.movements.last()
    }

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

    fun buildShip(builder: ShipBuilder) = builder.build(clock.now())

    fun findIslandEvents(
        pathMovement: Mobile,
        islands: List<Island>,
        onIslandEvent: (instant: Instant, island: Island) -> Event
    ): List<Event> {
        val intersection = findIntersectionPoints(pathMovement.getUniquePoints(), islands) ?: return emptyList()
        val u = findNearestU(intersection, pathMovement)
        return listOf(onIslandEvent(pathMovement.getInstant(u), intersection.island))
    }

    fun findFightEvents(pathMovement: Mobile, shipBuilders: List<ShipBuilder>) = buildList {
        val pathOutline = buildOutlinePlanes(pathMovement.getUniquePoints(), thickness = 5.0)
        val shipsInMovement = shipBuilders.filter { getMostRecentMovement(it.info) is Mobile }

        // for every ship in movement
        for (ship in shipsInMovement) {
            val movement = ship.info.movements as Mobile
            val index = (movement.getU(clock.now()) * 3).toInt() // plane index
            val otherOutline = buildOutlinePlanes(movement.getUniquePoints(), thickness = 5.0)

            // check every plane for an intersection with other planes
            for (i in pathOutline.indices) {
                val plane = pathOutline[i]
                val otherPlaneIndex = i + index
                // check if planes are overlapping
                if (plane.isOverlapping(otherOutline[otherPlaneIndex])) {
                    val pathSegment = pathMovement.landmarks[i / 3]
                        .split(start = i / 3.0, end = (i + 1) / 3.0)
                        .sample(5)
                    val otherPathSegment = pathMovement.landmarks[(otherPlaneIndex) / 3]
                        .split(start = otherPlaneIndex / 3.0, end = (otherPlaneIndex + 1) / 3.0)
                        .sample(5)

                    val u = comparePoints(pathSegment, otherPathSegment) / (5.0 * 3.0)
                    add(pathMovement.getInstant(u))
                }
            }
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