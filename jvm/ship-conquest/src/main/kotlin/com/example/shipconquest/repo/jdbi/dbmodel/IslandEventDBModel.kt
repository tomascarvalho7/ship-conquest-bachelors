package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.EventDetails
import com.example.shipconquest.domain.event.event_details.IslandEvent
import java.time.Instant

data class IslandEventDBModel(
    val tag: String,
    val eid: Int,
    val instant: Instant,
    val sid: Int,
    val islandId: Int,
)

fun IslandEventDBModel.toEvent() =
    Event(
        eid = eid,
        instant = instant,
        details = IslandEvent(
            sid = sid,
            islandId = islandId
        )
    )