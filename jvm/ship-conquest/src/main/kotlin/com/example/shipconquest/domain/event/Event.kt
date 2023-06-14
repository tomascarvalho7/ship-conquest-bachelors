package com.example.shipconquest.domain.event

import com.example.shipconquest.domain.event.event_details.EventDetails
import java.time.Duration
import java.time.Instant

/**
 * The [Event] data class holds the data for an event born from a player interaction
 * that happens at a given [instant], and has a unique id: [eid].
 */
data class Event(val eid: Int, val instant: Instant, val details: EventDetails)