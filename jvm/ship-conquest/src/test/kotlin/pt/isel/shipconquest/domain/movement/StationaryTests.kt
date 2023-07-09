package pt.isel.shipconquest.domain.movement

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import pt.isel.shipconquest.ClockStub
import pt.isel.shipconquest.domain.ship.movement.Stationary
import pt.isel.shipconquest.domain.space.Vector2
import java.time.Duration

class StationaryTests {
    private val clock = ClockStub()
    @Test
    fun `get always the same coordinate from stationary movement`() {
        // stationary movement
        val coordinate = Vector2(x = 10, y = 10)
        val movement = Stationary(coordinate = coordinate)
        val duration = Duration.ofDays(1)
        // assert that movement always returns the same movement for any instant
        assertEquals(coordinate, movement.getCoordinateFromInstant(clock.now()))
        assertEquals(coordinate, movement.getCoordinateFromInstant(clock.now() + duration))
        assertEquals(coordinate, movement.getCoordinateFromInstant(clock.now() - duration))
    }
}