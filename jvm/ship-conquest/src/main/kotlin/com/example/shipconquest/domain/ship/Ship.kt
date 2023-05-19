package com.example.shipconquest.domain.ship

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.FutureEvent
import com.example.shipconquest.domain.ship.movement.Movement

data class Ship(
    val sid: Int,
    val movement: Movement,
    val completedEvents: List<Event>,
    val futureEvents: List<FutureEvent>
)