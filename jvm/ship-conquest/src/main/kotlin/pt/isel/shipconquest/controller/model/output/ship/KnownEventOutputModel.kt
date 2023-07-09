package pt.isel.shipconquest.controller.model.output.ship

import pt.isel.shipconquest.controller.model.output.islands.IslandOutputModel
import pt.isel.shipconquest.controller.model.output.islands.toIslandOutputModel
import pt.isel.shipconquest.domain.event.Event
import pt.isel.shipconquest.domain.event.event_details.FightEvent
import pt.isel.shipconquest.domain.event.event_details.IslandEvent
import pt.isel.shipconquest.domain.event.event_details.isWinner


interface KnownEventOutputModel

data class FightEventOutputModel(val eid: Int, val instant: String, val won: Boolean): KnownEventOutputModel

data class IslandEventOutputModel(val eid: Int, val instant: String, val island: IslandOutputModel): KnownEventOutputModel

fun Event.toKnownEventOutputModel(sid: Int) = when(details) {
    is FightEvent -> FightEventOutputModel(
        eid = eid,
        instant = instant.toString(),
        won = details.isWinner(sid = sid)
    )
    is IslandEvent -> IslandEventOutputModel(
        eid = eid,
        instant = instant.toString(),
        island = details.island.toIslandOutputModel()
    )
}