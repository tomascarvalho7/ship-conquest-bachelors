package com.example.shipconquest.domain.event.event_details

import com.example.shipconquest.domain.ship_navigation.ship.movement.Mobile
import com.example.shipconquest.domain.ship_navigation.ship.movement.Stationary
import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement
import com.example.shipconquest.domain.toVector2
import java.time.Instant

data class IslandEvent(val sid: Int, val islandId: Int): EventDetails

fun IslandEvent.updateMovement(movement: Movement, instant: Instant) =
    // stop on island event
    Stationary(
        position = when(movement) {
            is Mobile -> movement.getPositionFromInstant(instant).toVector2()
            is Stationary -> movement.position
        }
    )