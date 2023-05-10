package com.example.shipconquest.domain.event

import com.example.shipconquest.domain.event.event_details.EventDetails
import java.time.Instant

data class Event(val eid: Int, val instant: Instant, val details: EventDetails)