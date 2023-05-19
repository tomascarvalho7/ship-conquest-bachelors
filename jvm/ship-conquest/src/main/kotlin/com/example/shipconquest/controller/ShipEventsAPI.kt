package com.example.shipconquest.controller

import com.example.shipconquest.controller.model.output.notification.buildEventNotification
import com.example.shipconquest.domain.event.FutureEvent
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.ship.Fleet
import com.example.shipconquest.domain.ship.Ship
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter

/**
 * Top API to handle Server Sent Events related to ship events
 * on top of the PublisherAPI
 */
object ShipEventsAPI {
    // n sid (Ship Identifiers) -> uid (User Identifiers)
    private var ships = mapOf<Int, String>()

    private fun buildEvent(id: String, data: Any) =
        SseEmitter
            .event()
            .id(id)
            //.name(name)
            .data(data)

    fun publishEvents(futureEvents: List<FutureEvent>) {
        for(futureEvent in futureEvents) {
            val details = futureEvent.event.details

            if (details is FightEvent) {
                // get enemy uid
                val key = ships[details.sidB]
                // notify enemy ship of new future event
                if (key != null) PublisherAPI.publish(
                    key = key,
                    message = buildEvent(
                        id = "${futureEvent.event.eid}",
                        data = buildEventNotification(sid = details.sidB, event = futureEvent)
                    )
                )
            }
        }
    }

    fun subscribeNewShipToFleetEvents(uid: String, ship: Ship) {
        // add a new entry of ship identifier pointing to user id
        ships = ships.plus(ship.sid to uid)
    }

    fun subscribeToFleetEvents(uid: String, fleet: Fleet): SseEmitter {
        // create new entry for each ship pointing to user id
        ships = ships.plus(
            fleet.ships.map { ship -> ship.sid to uid }
        )
        return PublisherAPI.subscribe(key = uid)
    }

    fun unsubscribeToFleetEvents(uid: String) {
        // remove fleet entries
        PublisherAPI.unsubscribe(key = uid);
    }
}