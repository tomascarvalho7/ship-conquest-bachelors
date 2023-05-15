package com.example.shipconquest.controller.model.output.ship

import com.example.shipconquest.domain.event.UnknownEvent
import com.example.shipconquest.service.formatDuration
import java.time.Instant

data class UnknownEventOutputModel(val info: String, val eid: Int, val duration: String)

fun UnknownEvent.toUnknownEventOutputModel() =
    UnknownEventOutputModel(
        info = "Upcoming unknown event.",
        eid = eid,
        duration = formatDuration(duration)
    )