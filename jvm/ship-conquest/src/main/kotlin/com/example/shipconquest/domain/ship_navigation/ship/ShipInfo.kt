package com.example.shipconquest.domain.ship_navigation.ship

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.event.event_details.updateMovement
import com.example.shipconquest.domain.ship_navigation.ship.movement.Movement
import java.time.Instant

data class ShipInfo(val id: Int, val movement: Movement)

