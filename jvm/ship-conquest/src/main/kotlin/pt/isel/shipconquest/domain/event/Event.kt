package pt.isel.shipconquest.domain.event

import pt.isel.shipconquest.domain.event.event_details.EventDetails
import java.time.Instant


/**
 * The [Event] data class holds the data for an event born from a player interaction
 * that happens at a given [instant], and has a unique id: [eid].
 */
data class Event(val eid: Int, val instant: Instant, val details: EventDetails)