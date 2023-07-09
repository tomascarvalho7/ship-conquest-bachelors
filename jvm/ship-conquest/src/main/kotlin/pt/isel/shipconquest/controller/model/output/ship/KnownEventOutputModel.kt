package pt.isel.shipconquest.controller.model.output.ship

import com.example.shipconquest.controller.model.output.islands.IslandOutputModel
import com.example.shipconquest.controller.model.output.islands.toIslandOutputModel
import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.domain.event.event_details.isWinner

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