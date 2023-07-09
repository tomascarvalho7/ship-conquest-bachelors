package pt.isel.shipconquest.domain.user.statistics

import java.time.Duration
import java.time.Instant
import java.time.Period
import kotlin.math.floor

/**
 * The [IslandIncome] data class holds the data for a player income
 * from his owned island.
 *
 * The [incomePerHour] value represents the currency given to the
 * player by the hour. The [conquestDate] value is the [Instant] since
 * this island has been owned by the player.
 */
data class IslandIncome(val incomePerHour: Int, val conquestDate: Instant)

/**
 * Extension function to get the Island currency since it's been owned
 */
fun IslandIncome.getCurrency(now: Instant): Int {
    val elapsedDuration = Duration.between(conquestDate, now)
    val seconds = elapsedDuration.toSecondsPart() / 3600.0
    val minutes = elapsedDuration.toMinutesPart() / 60.0
    val total = elapsedDuration.toHours().toDouble() + minutes + seconds

    return floor(total * incomePerHour).toInt()
}