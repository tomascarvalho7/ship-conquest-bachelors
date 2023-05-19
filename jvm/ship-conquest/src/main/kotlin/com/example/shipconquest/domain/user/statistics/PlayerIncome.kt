package com.example.shipconquest.domain.user.statistics

import java.lang.Integer.max
import java.lang.Integer.min
import java.time.Instant

data class PlayerIncome(val staticCurrency: Int, val passiveIncome: List<IslandIncome>)

fun PlayerIncome.getCurrency(now: Instant): Int {
    val totalPassiveInc = passiveIncome.sumOf { island -> island.getCurrency(now = now) }
    val allowedIncome = min(totalPassiveInc, getMaxCurrency() - staticCurrency)
    return staticCurrency + allowedIncome
}

fun PlayerIncome.getMaxCurrency(): Int =
    max(passiveIncome.sumOf { island -> island.incomePerHour * 24 }, 200)