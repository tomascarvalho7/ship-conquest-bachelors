package pt.isel.shipconquest.domain.event.event_details

import pt.isel.shipconquest.domain.event.FightInteraction


/**
 * The [FightEvent] data class holds the data for the details of a Fight event
 * between two ships.
 * The ships are represented by their ship-ids: [sidA] & [sidB].
 * The [winner] value represents the player who won the fight, either being
 * player A or player B.
 */
data class FightEvent(val sidA: Int, val sidB: Int, val winner: FightInteraction): EventDetails

// check if given [sid] (ship-id) won this [FightEvent]
fun FightEvent.isWinner(sid: Int) =
    sid == sidA && winner == FightInteraction.PLAYER_A ||
    sid == sidB && winner == FightInteraction.PLAYER_B