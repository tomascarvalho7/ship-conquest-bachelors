package com.example.shipconquest.domain.user.statistics

import java.time.Instant

data class PlayerStatistics(val currency: Int, val maxCurrency: Int)

fun PlayerStatsBuilder.build(now: Instant) =
    PlayerStatistics(
        currency = income.getCurrency(now),
        maxCurrency = income.getMaxCurrency()
    )