package com.example.shipconquest.domain.movement

import com.example.shipconquest.ClockStub
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.domain.space.Vector2
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
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