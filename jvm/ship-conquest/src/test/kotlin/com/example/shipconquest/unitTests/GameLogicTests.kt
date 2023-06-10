package com.example.shipconquest.unitTests

import com.example.shipconquest.Clock
import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.game.GameLogic
import com.example.shipconquest.domain.bezier.CubicBezier
import com.example.shipconquest.domain.ship.ShipBuilder
import com.example.shipconquest.domain.ship.ShipInfo
import com.example.shipconquest.domain.ship.movement.Mobile
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.domain.user.statistics.IslandIncome
import com.example.shipconquest.domain.user.statistics.PlayerIncome
import com.example.shipconquest.domain.user.statistics.PlayerStatsBuilder
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.OwnershipDetails
import com.example.shipconquest.domain.world.islands.WildIsland
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test
import java.time.Duration
import java.time.Instant

class ClockStub: Clock {
    override fun now(): Instant = Instant.parse("2023-01-01T00:00:00Z")
}

class GameLogicTests {
    private val testClock: Clock = ClockStub()

    @Test
    fun getInstant() {
        val gameLogic = GameLogic(testClock)

        val instant = gameLogic.getInstant()

        assertEquals(Instant.parse("2023-01-01T00:00:00Z"), instant)
    }

    @Test
    fun buildShipMovement() {
        val gameLogic = GameLogic(testClock)
        val points = listOf(
            Vector2(0, 0),
            Vector2(1, 0),
            Vector2(2, 0),
            Vector2(3, 0)
        )

        val movement = gameLogic.buildShipMovement(points)

        assertEquals(1, movement.landmarks.size)
        assertEquals(testClock.now(), movement.startTime)
        assertEquals(points, movement.getPoints())
    }

    @Test
    fun conquestWildIsland() {
        val gameLogic = GameLogic(testClock)
        val user = User(
            id = "FAKE-UID",
            name = "Adam"
        )
        val island = WildIsland(
            islandId = 123,
            coordinate = Vector2(10, 10),
            radius = 10
        )
        var onWildCalled = false
        var onOwnedCalled = false

        val ownedIsland = gameLogic.conquestIsland(user, island,
            onWild = { old, new ->
                onWildCalled = true
                assertEquals(island, old)
                assertEquals(user.id, new.uid)
                assertEquals(testClock.now(), new.conquestDate)
            },
            onOwned = { _, _ ->
                onOwnedCalled = true
            }
        )

        assertEquals(user.id, ownedIsland?.uid)
        assertEquals(testClock.now(), ownedIsland?.conquestDate)
        assertEquals(false, onOwnedCalled)
        assertEquals(true, onWildCalled)
    }

    @Test
    fun conquestOwnedIsland() {
        val gameLogic = GameLogic(testClock)
        val user = User(
            id = "FAKE-UID",
            name = "Adam"
        )
        val island = OwnedIsland(
            islandId = 123,
            coordinate = Vector2(10, 10),
            radius = 10,
            incomePerHour = 100,
            conquestDate = Instant.parse("2022-12-31T23:59:00Z"),
            uid = user.id,
            ownershipDetails = OwnershipDetails(owned = false, username = user.id)
        )
        var onWildCalled = false
        var onOwnedCalled = false

        val ownedIsland = gameLogic.conquestIsland(user, island,
            onWild = { _, _ ->
                onWildCalled = true
            },
            onOwned = { old, new ->
                onOwnedCalled = true
                assertEquals(island, old)
                assertEquals("otherUser", old.uid)
                assertEquals(user.id, new.uid)
                assertEquals(testClock.now(), new.conquestDate)
            }
        )

        assertEquals(user.id, ownedIsland?.uid)
        assertEquals(testClock.now(), ownedIsland?.conquestDate)
        assertEquals(true, onOwnedCalled)
        assertEquals(false, onWildCalled)
    }

    @Test
    fun conquestAlreadyOwnedIsland() {
        val gameLogic = GameLogic(testClock)
        val user = User(
            id = "FAKE-UID",
            name = "Adam"
        )
        val island = OwnedIsland(
            islandId = 123,
            coordinate = Vector2(10, 10),
            radius = 10,
            incomePerHour = 100,
            conquestDate = Instant.parse("2022-12-31T23:59:00Z"),
            uid = user.id,
            ownershipDetails = OwnershipDetails(owned = false, username = user.id)
        )
        var onWildCalled = false
        var onOwnedCalled = false

        val ownedIsland = gameLogic.conquestIsland(user, island,
            onWild = { _, _ ->
                onWildCalled = true
            },
            onOwned = { _, _ ->
                onOwnedCalled = true
            }
        )

        assertEquals(null, ownedIsland)
        assertEquals(false, onOwnedCalled)
        assertEquals(false, onWildCalled)
    }


    @Test
    fun getCoordFromMobileMovementAtStart() {
        val gameLogic = GameLogic(testClock)
        val movement = Mobile(
            landmarks = listOf(
                CubicBezier(Vector2(0, 0), Vector2(1, 0), Vector2(2, 0), Vector2(3, 0))
            ),
            startTime = testClock.now(),
            duration = Duration.ofHours(1)
        )

        val coordinate = gameLogic.getCoordFromMovement(movement)

        assertEquals(Vector2(0, 0), coordinate)
    }

    @Test
    fun getCoordFromMobileMovementAtMiddle() {
        val gameLogic = GameLogic(testClock)
        val movement = Mobile(
            landmarks = listOf(
                CubicBezier(Vector2(0, 0), Vector2(1, 0), Vector2(3, 0), Vector2(4, 0))
            ),
            startTime = testClock.now() - Duration.ofMinutes(30),
            duration = Duration.ofHours(1)
        )

        val coordinate = gameLogic.getCoordFromMovement(movement)

        assertEquals(Vector2(2, 0), coordinate)
    }

    @Test
    fun getCoordFromMobileMovementAtEnd() {
        val gameLogic = GameLogic(testClock)
        val movement = Mobile(
            landmarks = listOf(
                CubicBezier(Vector2(0, 0), Vector2(1, 0), Vector2(3, 0), Vector2(4, 0))
            ),
            startTime = testClock.now() - Duration.ofHours(1),
            duration = Duration.ofHours(1)
        )

        val coordinate = gameLogic.getCoordFromMovement(movement)

        assertEquals(Vector2(4, 0), coordinate)
    }

    @Test
    fun getCoordFromStationaryMovement() {
        val gameLogic = GameLogic(testClock)
        val coord = Vector2(0, 0)
        val movement = Stationary(coord)

        val coordinate = gameLogic.getCoordFromMovement(movement)

        assertEquals(coord, coordinate)
    }

    @Test
    fun buildPlayerStatisticsWithNoIslands() {
        val gameLogic = GameLogic(testClock)
        val playerIncome = PlayerIncome(staticCurrency = 125, passiveIncome = emptyList())
        val builder = PlayerStatsBuilder(tag = "ABC", uid = "user123", income = playerIncome);

        val statistics = gameLogic.buildPlayerStatistics(builder)

        // Verify
        assertEquals(125, statistics.currency)
        assertEquals(200, statistics.maxCurrency)
    }

    @Test
    fun buildPlayerStatisticsWithIslandForOneHour() {
        val gameLogic = GameLogic(testClock)
        val playerIncome = PlayerIncome(
            staticCurrency = 125,
            passiveIncome = listOf(
                // ownership of island, owned 1 hour ago, so island income should be 50
                IslandIncome(incomePerHour = 50, conquestDate = testClock.now() - Duration.ofHours(1))
            )
        )
        val builder = PlayerStatsBuilder(tag = "ABC", uid = "user123", income = playerIncome);

        val statistics = gameLogic.buildPlayerStatistics(builder)

        // Verify
        assertEquals(175, statistics.currency)
        assertEquals(1200, statistics.maxCurrency)
    }

    @Test
    fun buildPlayerStatisticsWithIslandForHalfHour() {
        val gameLogic = GameLogic(testClock)
        val playerIncome = PlayerIncome(
            staticCurrency = 125,
            passiveIncome = listOf(
                // ownership of island, owned 30 minutes ago, so island income should be 25
                IslandIncome(incomePerHour = 50, conquestDate = testClock.now() - Duration.ofMinutes(30))
            )
        )
        val builder = PlayerStatsBuilder(tag = "ABC", uid = "user123", income = playerIncome);

        val statistics = gameLogic.buildPlayerStatistics(builder)

        // Verify
        assertEquals(150, statistics.currency)
        assertEquals(1200, statistics.maxCurrency)
    }

    @Test
    fun buildPlayerStatisticsWithIslandForOneAndHalfHour() {
        val gameLogic = GameLogic(testClock)
        val playerIncome = PlayerIncome(
            staticCurrency = 125,
            passiveIncome = listOf(
                // ownership of island, owned 1 hour and 30 minutes ago, so island income should be 75
                IslandIncome(incomePerHour = 50, conquestDate = testClock.now() - Duration.ofMinutes(90))
            )
        )
        val builder = PlayerStatsBuilder(tag = "ABC", uid = "user123", income = playerIncome);

        val statistics = gameLogic.buildPlayerStatistics(builder)

        // Verify
        assertEquals(200, statistics.currency)
        assertEquals(1200, statistics.maxCurrency)
    }

    @Test
    fun shipFindIsland() {
        val gameLogic = GameLogic(testClock)
        val movement = Mobile(
            landmarks = listOf(
                CubicBezier(Vector2(1, 0), Vector2(4, 0), Vector2(7, 0), Vector2(10, 0))
            ),
            startTime = testClock.now(),
            duration = Duration.ofMinutes(10)
        )

        val island = WildIsland(
            islandId = 123,
            coordinate = Vector2(5, 5),
            radius = 10
        )

        val events = gameLogic.buildIslandEvents(
            pathMovement = movement,
            islands = listOf(island),
            onIslandEvent = { instant, island ->
                Event(
                    eid = 1234,
                    instant = instant,
                    details = IslandEvent(
                        sid = 12345,
                        island = island
                    )
                )
            }
        )

        // found event
        assertEquals(1, events.size)
        val event = events[0]
        assertTrue(event.details is IslandEvent)
    }

    @Test
    fun shipMissIsland() {
        val gameLogic = GameLogic(testClock)
        val movement = Mobile(
            landmarks = listOf(
                CubicBezier(Vector2(1, -5), Vector2(4, -5), Vector2(7, -5), Vector2(10, -5))
            ),
            startTime = testClock.now(),
            duration = Duration.ofMinutes(10)
        )

        val island = WildIsland(
            islandId = 123,
            coordinate = Vector2(5, 5),
            radius = 10
        )

        val events = gameLogic.buildIslandEvents(
            pathMovement = movement,
            islands = listOf(island),
            onIslandEvent = { instant, island ->
                Event(
                    eid = 1234,
                    instant = instant,
                    details = IslandEvent(
                        sid = 12345,
                        island = island
                    )
                )
            }
        )

        // found event
        assertEquals(0, events.size)
    }

    @Test
    fun shipFightAnotherShip() {
        val gameLogic = GameLogic(testClock)
        val movement = Mobile(
            landmarks = listOf(
                CubicBezier(Vector2(1, 4), Vector2(3, 4), Vector2(5, 4), Vector2(7, 4))
            ),
            startTime = testClock.now(),
            duration = Duration.ofMinutes(10)
        )
        val enemyMovement = Mobile(
            landmarks = listOf(
                CubicBezier(Vector2(4, -10), Vector2(4, -5), Vector2(4, 0), Vector2(4, 10))
            ),
            startTime = testClock.now(),
            duration = Duration.ofMinutes(10)
        )
        val ship = ShipBuilder(info = ShipInfo(id = 456, movements = listOf(movement)), events = emptyList())
        val enemyShip = ShipBuilder(info = ShipInfo(id = 123, movements = listOf(enemyMovement)), events = emptyList())
        val events = gameLogic.buildFightEvents(shipBuilder = ship, listOf(enemyShip)) { instant, fightEvent ->
            Event(
                eid = 1234,
                instant = instant,
                details = fightEvent
            )
        }

        assertEquals(1, events.size)
        val event = events[0]
        assertTrue(event.details is FightEvent)
    }

    @Test
    fun shipMissFightWithAnotherShip() {
        val gameLogic = GameLogic(testClock)
        val movement = Mobile(
            landmarks = listOf(
                CubicBezier(Vector2(1, 4), Vector2(3, 4), Vector2(5, 4), Vector2(7, 4))
            ),
            startTime = testClock.now(),
            duration = Duration.ofMinutes(10)
        )
        val enemyMovement = Mobile(
            landmarks = listOf(
                CubicBezier(Vector2(4, -20), Vector2(4, -15), Vector2(4, -10), Vector2(4, -5))
            ),
            startTime = testClock.now(),
            duration = Duration.ofMinutes(10)
        )
        val ship = ShipBuilder(info = ShipInfo(id = 456, movements = listOf(movement)), events = emptyList())
        val enemyShip = ShipBuilder(info = ShipInfo(id = 123, movements = listOf(enemyMovement)), events = emptyList())
        val events = gameLogic.buildFightEvents(shipBuilder = ship, listOf(enemyShip)) { instant, fightEvent ->
            Event(
                eid = 1234,
                instant = instant,
                details = fightEvent
            )
        }

        assertEquals(0, events.size)
    }
}
