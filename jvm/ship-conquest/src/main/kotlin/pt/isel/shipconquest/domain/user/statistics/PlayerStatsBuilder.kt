package pt.isel.shipconquest.domain.user.statistics

import java.time.Instant

/**
 * The [PlayerStatsBuilder] data class holds the data of the builder class of [PlayerStatistics].
 */
data class PlayerStatsBuilder(val tag: String, val uid: String, val income: PlayerIncome)

// The [PlayerStatistics] extension builder function from the [PlayerStatsBuilder] class
fun PlayerStatsBuilder.build(now: Instant) =
    PlayerStatistics(
        currency = income.getCurrency(now),
        maxCurrency = income.getMaxCurrency()
    )