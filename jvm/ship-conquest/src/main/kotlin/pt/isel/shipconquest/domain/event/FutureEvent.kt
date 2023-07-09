package pt.isel.shipconquest.domain.event

import java.time.Duration

/**
 * The [FutureEvent] data class holds the data for an [event] that
 * will happen at a given [duration].
 */
data class FutureEvent(val event: Event, val duration: Duration)