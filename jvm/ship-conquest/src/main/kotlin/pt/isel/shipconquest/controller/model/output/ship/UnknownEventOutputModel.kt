package pt.isel.shipconquest.controller.model.output.ship

import pt.isel.shipconquest.domain.event.FutureEvent
import pt.isel.shipconquest.domain.utils.formatDuration


data class UnknownEventOutputModel(val info: String, val eid: Int, val duration: String)

fun FutureEvent.toUnknownEventOutputModel() =
    UnknownEventOutputModel(
        info = "Upcoming unknown event.",
        eid = event.eid,
        duration = formatDuration(duration)
    )