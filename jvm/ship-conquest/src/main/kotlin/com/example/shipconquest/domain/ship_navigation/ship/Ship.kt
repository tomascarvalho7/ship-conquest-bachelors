package com.example.shipconquest.domain.ship_navigation.ship

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.UnknownEvent
import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement

data class Ship(
    val sid: Int,
    val movement: Movement,
    val completedEvents: List<Event>,
    val futureEvents: List<UnknownEvent>
)