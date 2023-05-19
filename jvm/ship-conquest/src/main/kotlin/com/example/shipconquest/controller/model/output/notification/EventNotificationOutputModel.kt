package com.example.shipconquest.controller.model.output.notification

import com.example.shipconquest.controller.model.output.ship.UnknownEventOutputModel
import com.example.shipconquest.controller.model.output.ship.toUnknownEventOutputModel
import com.example.shipconquest.domain.event.FutureEvent

data class EventNotificationOutputModel(val sid: Int, val event: UnknownEventOutputModel)

fun buildEventNotification(sid: Int, event: FutureEvent) =
    EventNotificationOutputModel(
        sid = sid,
        event = event.toUnknownEventOutputModel()
    )