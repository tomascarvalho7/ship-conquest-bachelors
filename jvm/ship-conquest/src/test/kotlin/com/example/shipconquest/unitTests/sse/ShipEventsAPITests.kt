package com.example.shipconquest.unitTests.sse

import com.example.shipconquest.ClockStub
import com.example.shipconquest.controller.sse.GameKey
import com.example.shipconquest.controller.sse.GameSubscriptionKey
import com.example.shipconquest.controller.sse.ShipEventsAPI
import com.example.shipconquest.controller.sse.publisher.PublisherMock
import com.example.shipconquest.controller.sse.toCode
import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.FightInteraction
import com.example.shipconquest.domain.event.FutureEvent
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.ship.Fleet
import com.example.shipconquest.domain.ship.Ship
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.domain.space.Vector2
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import java.time.Duration
import java.util.concurrent.ConcurrentHashMap

class ShipEventsAPITests {
    // constants
    private val tag = "gameA"
    private val clockStub = ClockStub()
    private val fakeEvent = FutureEvent(
        event = Event(
            eid = 1,
            instant = clockStub.now(),
            details = FightEvent(sidA = 2, sidB = 1, winner = FightInteraction.PLAYER_A)
        ),
        duration = Duration.ofMinutes(1)
    )

    @Test
    fun `test publishing zero events`() {
        // setup
        val data = mutableMapOf<String, Int>()
        val mock = PublisherMock(data)
        val ships = ConcurrentHashMap<GameKey, GameSubscriptionKey>()
        val shipEventsAPI = ShipEventsAPI(mock, ships)

        shipEventsAPI.publishEvents(tag = tag, futureEvents = emptyList())
        // assert that publish was not called
        assertEquals(0, data["publish"] ?: 0)
    }

    @Test
    fun `test publishing two events when not subscribed`() {
        // setup
        val data = mutableMapOf<String, Int>()
        val mock = PublisherMock(data)
        val ships = ConcurrentHashMap<GameKey, GameSubscriptionKey>()
        val shipEventsAPI = ShipEventsAPI(mock, ships)

        val events = listOf(fakeEvent, fakeEvent) // list of two fake events
        shipEventsAPI.publishEvents(tag = tag, futureEvents = events)
        // assert that publish was not called
        assertEquals(0, data["publish"] ?: 0)
    }

    @Test
    fun `test publishing two events when subscribed`() {
        // setup
        val data = mutableMapOf<String, Int>()
        val mock = PublisherMock(data)
        val uid = "FakeUID"
        val ships = ConcurrentHashMap<GameKey, GameSubscriptionKey>(
            mapOf(
                 GameKey(tag = tag, sid = 1) to GameSubscriptionKey(tag = tag, uid = uid)
            )
        )
        val shipEventsAPI = ShipEventsAPI(mock, ships)

        val events = listOf(fakeEvent, fakeEvent) // list of two fake events
        shipEventsAPI.publishEvents(tag = tag, futureEvents = events)
        // assert that publish was called twice
        assertEquals(2, data["publish"] ?: 0)
    }

    @Test
    fun `subscribe a new ship to fleet events`() {
        // setup
        val data = mutableMapOf<String, Int>()
        val mock = PublisherMock(data)
        // fake identifiers
        val sid = 1
        val uid = "FakeUID"
        val gameKey = GameKey(tag = tag, sid = sid)
        val gameSubscriptionKey = GameSubscriptionKey(tag = tag, uid = uid)
        val ships = ConcurrentHashMap<GameKey, GameSubscriptionKey>()
        val shipEventsAPI = ShipEventsAPI(mock, ships)

        // add a new GameKey - GameSubscriptionKey entry to the subscriptions
        val fakeShip = createFakeShip(sid)
        shipEventsAPI.subscribeNewShipToFleetEvents(tag, uid, fakeShip)
        // verify
        assertEquals(gameSubscriptionKey, ships[gameKey])
    }

    @Test
    fun `subscribe fleet to events`() {
        // setup
        val data = mutableMapOf<String, Int>()
        val mock = PublisherMock(data)
        val uid = "FakeUID"
        val ships = ConcurrentHashMap<GameKey, GameSubscriptionKey>()
        val shipEventsAPI = ShipEventsAPI(mock, ships)
        val fleet = Fleet(
            listOf(createFakeShip(1), createFakeShip(2))
        )
        // Call the method under test
        shipEventsAPI.subscribeToFleetEvents(tag, uid, fleet)

        // verify that subscription exists
        val expectedKey = GameSubscriptionKey(tag, uid)
        for (ship in fleet.ships) {
            assertEquals(expectedKey, ships[GameKey(tag = tag, sid = ship.sid)])
        }
        // verify that method subscribe was called
        assertEquals(1, data["subscribe"])
    }

    @Test
    fun `unsubscribe fleet to events`() {
        // setup
        val data = mutableMapOf<String, Int>()
        val mock = PublisherMock(data)
        val sid = 123
        val uid = "FakeUID"
        val ships = ConcurrentHashMap<GameKey, GameSubscriptionKey>()
        val shipEventsAPI = ShipEventsAPI(mock, ships)
        val key = GameSubscriptionKey(tag, uid)
        ships[GameKey(tag, sid)] = key

        // Call the method under test
        val result = shipEventsAPI.unsubscribeToFleetEvents(tag, uid)

        // verify that method unsubscribe was called
        assertEquals(1, data["unsubscribe"])
        assertEquals(null, ships[GameKey(tag, sid)])
        assertEquals(key.toCode(), result)
    }

    @Test
    fun `unsubscribe not subscribed fleet`() {
        // setup
        val data = mutableMapOf<String, Int>()
        val mock = PublisherMock(data)
        val sid = 123
        val uid = "FakeUID"
        val ships = ConcurrentHashMap<GameKey, GameSubscriptionKey>()
        val shipEventsAPI = ShipEventsAPI(mock, ships)
        val key = GameSubscriptionKey(tag, uid)

        // verify that it's unsubscribed
        assertEquals(null, ships[GameKey(tag, sid)])

        // Call the method under test
        val result = shipEventsAPI.unsubscribeToFleetEvents(tag, uid)

        // verify that method unsubscribe was called
        assertEquals(1, data["unsubscribe"])
        assertEquals(null, ships[GameKey(tag, sid)])
    }

    private fun createFakeShip(id: Int) =
        Ship(id, Stationary(Vector2(0, 0)), emptyList(), emptyList())
}