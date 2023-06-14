package com.example.shipconquest.domain.event.event_details

import com.example.shipconquest.domain.event.FightInteraction
import com.example.shipconquest.domain.ship.movement.Movement
import java.time.Instant

data class FightEvent(val sidA: Int, val sidB: Int, val winner: FightInteraction): EventDetails

fun FightEvent.isWinner(sid: Int) =
    sid == sidA && winner == FightInteraction.PLAYER_A ||
    sid == sidB && winner == FightInteraction.PLAYER_B

fun FightEvent.updateMovement(movement: Movement, instant: Instant) = movement