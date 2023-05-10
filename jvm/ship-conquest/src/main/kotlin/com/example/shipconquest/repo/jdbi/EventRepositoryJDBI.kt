package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.event.Event
import com.example.shipconquest.domain.event.event_details.EventDetails
import com.example.shipconquest.domain.event.event_details.FightEvent
import com.example.shipconquest.domain.event.event_details.IslandEvent
import com.example.shipconquest.repo.EventRepository
import com.example.shipconquest.repo.jdbi.dbmodel.FightEventDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.IslandEventDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.toEvent
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.time.Instant

class EventRepositoryJDBI(private val handle: Handle): EventRepository {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)
    override fun createFightingEvent(tag: String, instant: Instant, details: FightEvent): Event {
        logger.info("Creating Fighting event in instant = {}", instant.toString())

        val eid = handle.createUpdate(
            """
               INSERT INTO dbo.FightEvent (tag, instant, sidA, sidB, winner)
               values (:tag, :instant, :sidA, :sidB, :winner)
            """
        )
            .bind("tag", tag)
            .bind("instant", instant.epochSecond)
            .bind("sidA", details.sidA)
            .bind("sidB", details.sidB)
            .bind("winner", details.winner)
            .executeAndReturnGeneratedKeys("eid")
            .mapTo<Int>()
            .single()

        return Event(eid = eid, instant = instant, details = details)
    }

    override fun createIslandEvent(tag: String, instant: Instant, details: IslandEvent): Event {
        logger.info("Creating Island event in instant = {}", instant.toString())

        val eid = handle.createUpdate(
            """
               INSERT INTO dbo.IslandEvent (tag, instant, sid, islandId)
               values (:tag, :instant, :sid, :islandId)
            """
        )
            .bind("tag", tag)
            .bind("instant", instant.epochSecond)
            .bind("sid", details.sid)
            .bind("islandId", details.islandId)
            .executeAndReturnGeneratedKeys("eid")
            .mapTo<Int>()
            .single()

        return Event(eid = eid, instant = instant, details = details)
    }

    override fun getShipEvents(tag: String, sid: Int): List<Event> {
        logger.info("Getting events from ship with id = {} on game with tag = {}", sid, tag)

        val fightEvents = handle.createQuery(
            """
                SELECT * FROM dbo.FightEvent WHERE tag = :tag AND (sidA = :sid OR sidB = :sid)
            """
        )
            .bind("tag", tag)
            .bind("sid", sid)
            .mapTo<FightEventDBModel>()
            .toList()
            .map { it.toEvent() }

        val islandEvents = handle.createQuery(
            """
                SELECT * FROM dbo.IslandEvent WHERE tag = :tag AND sid = :sid
            """
        )
            .bind("tag", tag)
            .bind("sid", sid)
            .mapTo<IslandEventDBModel>()
            .toList()
            .map { it.toEvent() }

        return fightEvents + islandEvents
    }

    override fun getShipEventsAfterInstant(tag: String, sid: Int, instant: Instant): List<Event> {
        logger.info("Getting events after instant from ship with id = {} on game with tag = {}", sid, tag)

        val fightEvents = handle.createQuery(
            """
                SELECT * FROM dbo.FightEvent 
                WHERE tag = :tag AND instant > :instant AND AND (sidA = :sid OR sidB = :sid)
            """
        )
            .bind("tag", tag)
            .bind("sid", sid)
            .bind("instant", instant.epochSecond)
            .mapTo<FightEventDBModel>()
            .toList()
            .map { it.toEvent() }

        val islandEvents = handle.createQuery(
            """
                SELECT * FROM dbo.IslandEvent 
                WHERE tag = :tag AND sid = :sid AND instant > :instant
            """
        )
            .bind("tag", tag)
            .bind("sid", sid)
            .bind("instant", instant.epochSecond)
            .mapTo<IslandEventDBModel>()
            .toList()
            .map { it.toEvent() }

        return fightEvents + islandEvents
    }

    override fun deleteShipEventsAfterInstant(tag: String, sid: Int, instant: Instant) {
        logger.info("Deleting events from ship with id = {} on game with tag = {}", sid, tag)

        handle.createUpdate(
            """
                DELETE FROM dbo.FightEvent 
                WHERE tag = :tag AND instant > :instant AND (sidA = :sid OR sidB = :sid)
            """
        )
            .bind("tag", tag)
            .bind("sid", sid)
            .bind("instant", instant.epochSecond)
            .execute()

        handle.createUpdate(
            """
                DELETE FROM dbo.IslandEvent WHERE tag = :tag AND sid = :sid AND instant > :instant
            """
        )
            .bind("tag", tag)
            .bind("sid", sid)
            .bind("instant", instant.epochSecond)
            .execute()
    }
}