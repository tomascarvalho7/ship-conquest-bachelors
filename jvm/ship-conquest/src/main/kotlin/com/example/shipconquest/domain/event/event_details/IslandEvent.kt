package com.example.shipconquest.domain.event.event_details

import com.example.shipconquest.domain.ship.movement.Mobile
import com.example.shipconquest.domain.ship.movement.Movement
import com.example.shipconquest.domain.ship.movement.Stationary
import com.example.shipconquest.domain.world.islands.Island
import java.time.Instant

data class IslandEvent(val sid: Int, val island: Island): EventDetails

fun IslandEvent.updateMovement(movement: Movement, instant: Instant) =
    // stop on island event
    when(movement) {
        is Mobile -> if(instant.isAfter(movement.startTime) && instant.isBefore(movement.startTime + movement.duration)) {
            Mobile(
                landmarks = movement.splitPathBeforeTime(instant),
                startTime = movement.startTime,
                duration = movement.duration
            )
        } else {
            movement
        }
        is Stationary ->
            Stationary(
                position = movement.position
            )
    }