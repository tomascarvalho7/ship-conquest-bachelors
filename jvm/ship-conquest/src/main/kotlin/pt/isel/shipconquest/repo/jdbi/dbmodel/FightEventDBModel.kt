package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.EventDetails
import com.example.shipconquest.domain.event.FightInteraction
import com.example.shipconquest.domain.event.event_details.FightEvent
import java.time.Instant

data class FightEventDBModel(
    val tag: String,
    val eid: Int,
    val instant: Instant,
    val sidA: Int,
    val sidB: Int,
    val winner: Int
)

fun FightEventDBModel.toEvent() =
    Event(
        eid = eid,
        instant = instant,
        details = FightEvent(
            sidA = sidA,
            sidB = sidB,
            winner = decodeToWinner(winner)
        )
    )

fun decodeToWinner(value: Int) =
        when(value) {
            0 -> FightInteraction.PLAYER_A
            1 -> FightInteraction.PLAYER_B
            else -> throw IllegalStateException()
        }