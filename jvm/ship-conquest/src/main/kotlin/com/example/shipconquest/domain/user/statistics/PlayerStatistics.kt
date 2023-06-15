package com.example.shipconquest.domain.user.statistics

import java.time.Instant

/**
 * The [PlayerStatistics] data class holds the static representation of a player's current
 * [currency] and [maxCurrency] at a certain [Instant].
 */
data class PlayerStatistics(val currency: Int, val maxCurrency: Int)