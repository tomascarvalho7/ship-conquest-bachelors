package com.example.shipconquest.controller

import com.example.shipconquest.controller.model.output.notification.EventNotificationOutputModel
import com.example.shipconquest.controller.model.output.notification.buildEventNotification
import com.example.shipconquest.controller.model.output.ship.FleetOutputModel
import com.example.shipconquest.controller.model.output.ship.toFleetOutputModel
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
    // (N) gameKey (Tag, Ship Identifier) -> gameSubscriptionKey(Tag, User identifier)
    private var ships = mapOf<GameKey, GameSubscriptionKey>()

    private fun buildEvent(id: String, data: EventNotificationOutputModel) =
        SseEmitter
            .event()
            .id(id)
            .name("event")
            .data(data)
            .build()

    private fun buildEvent(id: String, data: FleetOutputModel) =
        SseEmitter
            .event()
            .id(id)
            .name("fleet")
            .data(data)
            .build()

    fun publishFleet(tag: String, uid: String, fleet: Fleet) {
        val key = GameSubscriptionKey(tag = tag, uid = uid)
        PublisherAPI.publish(
            key = key.toCode(),
            message = buildEvent(
                id = key.toCode(),
                data = fleet.toFleetOutputModel()
            )
        )
    }

    fun publishEvents(tag: String, futureEvents: List<FutureEvent>) {
        for(futureEvent in futureEvents) {
            val details = futureEvent.event.details

            if (details is FightEvent) {
                // get enemy uid
                val key = ships[GameKey(tag = tag, sid = details.sidB)]
                // notify enemy ship of new future event
                if (key != null) PublisherAPI.publish(
                    key = key.toCode(),
                    message = buildEvent(
                        id = "${futureEvent.event.eid}",
                        data = buildEventNotification(sid = details.sidB, event = futureEvent)
                    )
                )
            }
        }
    }

    fun subscribeNewShipToFleetEvents(tag: String, uid: String, ship: Ship) {
        // add a new entry of ship identifier pointing to user id
        ships = ships.plus(
            GameKey(tag = tag, sid = ship.sid) to GameSubscriptionKey(tag = tag, uid = uid)
        )
    }

    fun subscribeToFleetEvents(tag: String, uid: String, fleet: Fleet): SseEmitter {
        // create new entry for each ship pointing to user id
        val key = GameSubscriptionKey(tag = tag, uid = uid)
        ships = ships.plus(
            fleet.ships.map { ship ->
                GameKey(tag = tag, sid = ship.sid) to key
            }
        )
        return PublisherAPI.subscribe(key = key.toCode())
    }

    fun unsubscribeToFleetEvents(tag: String, uid: String) {
        // remove fleet entries
        PublisherAPI.unsubscribe(key = GameSubscriptionKey(tag = tag, uid = uid).toCode())
    }
}

data class GameKey(val tag: String, val sid: Int)

data class GameSubscriptionKey(val tag: String, val uid: String)

fun GameSubscriptionKey.toCode() = hashCode().toString()