package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.repo.IslandRepository
import com.example.shipconquest.repo.jdbi.dbmodel.island.*
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.slf4j.Logger
import org.slf4j.LoggerFactory

class IslandRepositoryJDBI(private val handle: Handle): IslandRepository {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    override fun get(tag: String, islandId: Int): Island? {
        logger.info("Getting island from db with tag = {} and islandId = {}", tag, islandId)

        return handle.createQuery(
            """
               select * from dbo.Island where tag = :tag AND islandId = :id
            """
        )
            .bind("tag", tag)
            .bind("id", islandId)
            .mapTo<GenericIslandDBModel>()
            .singleOrNull()
            ?.toIsland()
    }

    override fun getAll(tag: String): List<Island> {
        logger.info("Getting all island's from db with tag = {}", tag)

        return handle.createQuery(
            """
               select * from dbo.Island where tag = :tag
            """
        )
            .bind("tag", tag)
            .mapTo<GenericIslandDBModel>()
            .map { it.toIsland() }
            .list()
    }

    override fun getVisitedIslands(tag: String, uid: String): List<Island> {
        logger.info("Getting visited islands by user with uid = {} on game with tag = {}", uid, tag)

        return handle.createQuery(
            """
                SELECT * FROM dbo.Island
                WHERE tag = :tag AND islandId IN (
                    SELECT islandId FROM dbo.IslandEvent I 
                    INNER JOIN dbo.Ship S ON I.sid = S.shipId
                    WHERE tag = :tag AND uid = :uid
                )
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<GenericIslandDBModel>()
            .map { it.toIsland() }
            .list()
    }

    override fun getUnvisitedIslands(tag: String, uid: String): List<Island> {
        logger.info("Getting unvisited islands by user with uid = {} on game with tag = {}", uid, tag)

        return handle.createQuery(
            """
                SELECT * FROM dbo.Island
                WHERE tag = :tag AND islandId NOT IN (
                    SELECT islandId FROM dbo.IslandEvent I 
                    INNER JOIN dbo.Ship S ON I.sid = S.shipId
                    WHERE tag = :tag AND uid = :uid
                )
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<GenericIslandDBModel>()
            .map { it.toIsland() }
            .list()
    }

    override fun create(tag: String, origin: Vector2, radius: Int) {
        logger.info("Creating island on game with tag = {}", tag)

        handle.createUpdate(
            """
                insert into dbo.Island(tag, x, y, radius) values(:tag, :x, :y, :radius)
            """
        )
            .bind("tag", tag)
            .bind("x", origin.x)
            .bind("y", origin.y)
            .bind("radius", radius)
            .execute()
    }

    override fun updateOwnedIsland(tag: String, island: OwnedIsland) {
        logger.info("Island with id = {} on game = {} is now owned by = {}",
            island.islandId, tag, island.uid)

        handle.createUpdate(
            """
                UPDATE dbo.OwnedIsland SET 
                incomePerHour = :incomePerHour
                instant = :instant
                uid = :uid
                WHERE tag = :tag AND islandId = :id
            """
        )
            .bind("tag", tag)
            .bind("id", island.islandId)
            .bind("incomePerHour", island.incomePerHour)
            .bind("instant", island.conquestDate.epochSecond)
            .bind("uid", island.uid)
            .execute()
    }

    override fun wildToOwnedIsland(tag: String, island: OwnedIsland) {
        logger.info("Wild island with id = {} on game = {} is now owned by = {}", island.islandId, tag, island.uid)

        handle.createUpdate(
            """
               DELETE FROM dbo.Island WHERE tag = :tag AND islandId = :id
            """
        )
            .bind("tag", tag)
            .bind("id", island.islandId)
            .execute()

        handle.createUpdate(
            """
                INSERT INTO dbo.OwnedIsland(islandId, tag, x, y, radius, incomePerHour, instant, uid) 
                values(:islandId, :tag, :x, :y, :radius, :incomePerHour, :instant, :uid)
            """
        )
            .bind("islandId", island.islandId)
            .bind("tag", tag)
            .bind("x", island.coordinate.x)
            .bind("y", island.coordinate.y)
            .bind("radius", island.radius)
            .bind("incomePerHour", island.incomePerHour)
            .bind("instant", island.conquestDate.epochSecond)
            .bind("uid", island.uid)
            .execute()
    }
}