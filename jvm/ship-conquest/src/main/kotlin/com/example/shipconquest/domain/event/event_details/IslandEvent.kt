package com.example.shipconquest.domain.event.event_details

import com.example.shipconquest.domain.ship_navigation.ship.movement.Mobile
import com.example.shipconquest.domain.ship_navigation.ship.movement.Stationary
import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement
import com.example.shipconquest.domain.toVector2
import com.example.shipconquest.domain.world.islands.Island
import java.time.Instant

data class IslandEvent(val sid: Int, val island: Island): EventDetails

fun IslandEvent.updateMovement(movement: Movement, instant: Instant) =
    // stop on island event
    when(movement) {
        is Mobile ->
            Mobile(
                landmarks = movement.splitPathBeforeTime(instant),
                startTime = movement.startTime,
                duration = movement.duration
            )
        is Stationary ->
            Stationary(
                position = movement.position
            )
    }