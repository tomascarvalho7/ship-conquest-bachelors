package com.example.shipconquest.controller.model.output.ship

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.FutureEvent
import com.example.shipconquest.service.formatDuration

data class UnknownEventOutputModel(val info: String, val eid: Int, val duration: String)

fun FutureEvent.toUnknownEventOutputModel() =
    UnknownEventOutputModel(
        info = "Upcoming unknown event.",
        eid = event.eid,
        duration = formatDuration(duration)
    )