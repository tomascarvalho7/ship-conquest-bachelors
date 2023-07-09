package pt.isel.shipconquest.domain.utils

import java.text.SimpleDateFormat
import java.time.Duration
import java.time.Instant
import java.util.*

/**
 * Extension function that returns the result of the condition: is instant between start & end.
 */
fun Instant.isBetween(start: Instant, end: Instant) =
    isBefore(end) && isAfter(start)

/**
 * function to build a string with a defined format representing a duration
 */
fun formatDuration(durationString: Duration): String {
    val durationMillis = durationString.toMillis()

    val dateFormat = SimpleDateFormat("mm:ss.SSS")
    dateFormat.timeZone = TimeZone.getTimeZone("UTC")

    return dateFormat.format(Date(durationMillis))
}
