package pt.isel.shipconquest.repo.jdbi.dbmodel

import pt.isel.shipconquest.domain.event.Event
import pt.isel.shipconquest.domain.event.event_details.IslandEvent
import pt.isel.shipconquest.domain.world.islands.Island
import java.time.Instant

data class IslandEventDBModel(
    val tag: String,
    val eid: Int,
    val instant: Instant,
    val sid: Int,
    val islandId: Int,
)

fun IslandEventDBModel.toEvent(island: Island) =
    Event(
        eid = eid,
        instant = instant,
        details = IslandEvent(
            sid = sid,
            island = island
        )
    )