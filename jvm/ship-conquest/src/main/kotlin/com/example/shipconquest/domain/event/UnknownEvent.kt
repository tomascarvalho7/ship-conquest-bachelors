package com.example.shipconquest.domain.event

import java.time.Duration
import java.time.Instant

data class UnknownEvent(val eid: Int, val duration: Duration)

fun Event.toUnknownEvent(now: Instant) =
    UnknownEvent(eid = eid, duration = Duration.between(now, instant))