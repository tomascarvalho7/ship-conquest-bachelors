package pt.isel.shipconquest.controller.sse


import org.springframework.web.servlet.mvc.method.annotation.SseEmitter
import pt.isel.shipconquest.controller.model.output.notification.EventNotificationOutputModel
import pt.isel.shipconquest.controller.model.output.notification.buildEventNotification
import pt.isel.shipconquest.controller.model.output.ship.FleetOutputModel
import pt.isel.shipconquest.controller.model.output.ship.toFleetOutputModel
import pt.isel.shipconquest.controller.sse.publisher.SubscriptionManagerAPI
import pt.isel.shipconquest.domain.event.FutureEvent
import pt.isel.shipconquest.domain.event.event_details.FightEvent
import pt.isel.shipconquest.domain.ship.Fleet
import pt.isel.shipconquest.domain.ship.Ship
import java.util.concurrent.ConcurrentHashMap

/**
 * Top API to handle Server Sent Events related to ship events
 * on top of the PublisherAPI
 */
class ShipEventsAPI(
    private val publisherAPI: SubscriptionManagerAPI,
    private val ships: ConcurrentHashMap<GameKey, GameSubscriptionKey>
) {
    fun publishEvents(tag: String, futureEvents: List<FutureEvent>) {
        for(futureEvent in futureEvents) {
            val details = futureEvent.event.details

            if (details is FightEvent) {
                // get enemy uid
                val key = ships[GameKey(tag = tag, sid = details.sidB)]
                // notify enemy ship of new future event
                if (key != null) publisherAPI.publish(
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
        ships.putIfAbsent(
            GameKey(tag = tag, sid = ship.sid),
            GameSubscriptionKey(tag = tag, uid = uid)
        )
    }

    fun subscribeToFleetEvents(tag: String, uid: String, fleet: Fleet): SseEmitter {
        // create new entry for each ship pointing to user id
        val key = GameSubscriptionKey(tag = tag, uid = uid)
        ships.putAll(
            fleet.ships.map { ship ->
                GameKey(tag = tag, sid = ship.sid) to key
            }
        )
        // subscribe
        val emitter = publisherAPI.subscribe(key = key.toCode())
        // publish fleet
        publishFleet(tag = tag, uid = uid, fleet = fleet)

        return emitter
    }

    private fun buildEvent(id: String, data: EventNotificationOutputModel) =
        publisherAPI.createEvent(id, "event", data)

    private fun buildEvent(id: String, data: FleetOutputModel) =
        publisherAPI.createEvent(id, "fleet", data)

    private fun publishFleet(tag: String, uid: String, fleet: Fleet) {
        val key = GameSubscriptionKey(tag = tag, uid = uid)
        val code = key.toCode()
        publisherAPI.publish(
            key = code,
            message = buildEvent(
                id = code,
                data = fleet.toFleetOutputModel()
            )
        )
    }

    fun unsubscribeToFleetEvents(tag: String, uid: String): String {
        val gameSubscription = GameSubscriptionKey(tag = tag, uid = uid)
        ships.filter { (_, value) -> value == gameSubscription }.keys.forEach { key ->
            ships.remove(key) // remove
        }

        return publisherAPI.unsubscribe(
            key = gameSubscription.toCode()
        )
    }
}

data class GameKey(val tag: String, val sid: Int)

data class GameSubscriptionKey(val tag: String, val uid: String)

fun GameSubscriptionKey.toCode() = hashCode().toString()