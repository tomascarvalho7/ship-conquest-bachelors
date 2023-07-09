package pt.isel.shipconquest.controller.model.output.notification

import pt.isel.shipconquest.controller.model.output.ship.UnknownEventOutputModel
import pt.isel.shipconquest.controller.model.output.ship.toUnknownEventOutputModel
import pt.isel.shipconquest.domain.event.FutureEvent


data class EventNotificationOutputModel(val sid: Int, val event: UnknownEventOutputModel)

fun buildEventNotification(sid: Int, event: FutureEvent) =
    EventNotificationOutputModel(
        sid = sid,
        event = event.toUnknownEventOutputModel()
    )