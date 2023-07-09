package pt.isel.shipconquest.repo.jdbi.dbmodel

import pt.isel.shipconquest.domain.event.Event
import pt.isel.shipconquest.domain.event.FightInteraction
import pt.isel.shipconquest.domain.event.event_details.FightEvent
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