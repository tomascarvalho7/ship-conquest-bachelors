package pt.isel.shipconquest.repo

import org.slf4j.Logger
import pt.isel.shipconquest.domain.event.Event
import pt.isel.shipconquest.domain.event.event_details.FightEvent
import pt.isel.shipconquest.domain.event.event_details.IslandEvent
import java.time.Instant

interface EventRepository {
    val logger: Logger
    fun createFightingEvent(tag: String, instant: Instant, details: FightEvent): Event
    fun createIslandEvent(tag: String, instant: Instant, details: IslandEvent): Event
    fun getShipEvents(tag: String, uid: String, sid: Int): List<Event>
    fun getIslandEventsBeforeInstant(tag: String, uid: String, sid: Int, instant: Instant): List<Event>
    fun getShipEventsAfterInstant(tag: String, uid: String, sid: Int, instant: Instant): List<Event>

    fun deleteShipEventsAfterInstant(tag: String, sid: Int, instant: Instant)
}