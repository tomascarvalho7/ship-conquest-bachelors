package com.example.shipconquest.controller.model.output.ship

import com.example.shipconquest.domain.event.Event

data class UnknownEventOutputModel(val info: String, val eid: Int, val instant: String)

fun Event.toUnknownEventOutputModel() =
    UnknownEventOutputModel(
        info = "Upcoming unknown event.",
        eid = eid,
        instant = instant.toString()
    )