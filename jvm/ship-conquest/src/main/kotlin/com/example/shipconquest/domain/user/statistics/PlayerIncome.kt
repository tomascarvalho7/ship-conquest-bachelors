package com.example.shipconquest.domain.user.statistics

import java.lang.Integer.max
import java.lang.Integer.min
import java.time.Instant

/**
 * The [PlayerIncome] data class holds the data for the player income and currency builder.
 *
 * The [staticCurrency] value is the static and non-changing currency of the player.
 * Meanwhile, the [passiveIncome] value is the income that changes over time,
 * and is made out of a list of [IslandIncome] elements.
 */
data class PlayerIncome(val staticCurrency: Int, val passiveIncome: List<IslandIncome>)

// get total currency from player at a given [Instant]
fun PlayerIncome.getCurrency(now: Instant): Int {
    val totalPassiveInc = passiveIncome.sumOf { island -> island.getCurrency(now = now) }
    val allowedIncome = min(totalPassiveInc, getMaxCurrency() - staticCurrency)
    return staticCurrency + allowedIncome
}

// get the maximum possible currency a player is allowed to have
fun PlayerIncome.getMaxCurrency(): Int =
    max(passiveIncome.sumOf { island -> island.incomePerHour * 24 }, 200)