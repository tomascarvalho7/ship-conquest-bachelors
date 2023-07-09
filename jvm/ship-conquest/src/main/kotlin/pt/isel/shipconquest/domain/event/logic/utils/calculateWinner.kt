package pt.isel.shipconquest.domain.event.logic.utils

import com.example.shipconquest.domain.event.FightInteraction

fun calculateWinner(): FightInteraction {
    while(true) {
        val a = Math.random() // calculate chance of A winning
        val b = Math.random() // calculate chance of B winning
        when {
            a > b -> return FightInteraction.PLAYER_A
            a < b -> return FightInteraction.PLAYER_B
            else -> { /* if equal try again */}
        }
    }
}