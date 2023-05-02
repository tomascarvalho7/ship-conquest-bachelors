package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.repo.IslandRepository
import com.example.shipconquest.repo.jdbi.dbmodel.OwnedIslandDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.WildIslandDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.toOwnedIsland
import com.example.shipconquest.repo.jdbi.dbmodel.toWildIsland
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import java.time.Instant
import java.util.*

class IslandRepositoryJDBI(private val handle: Handle): IslandRepository {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    override fun get(tag: String, islandId: Int): Island? {
        logger.info("Getting island from db with tag = {} and islandId = {}", tag, islandId)

        val wildIsland = handle.createQuery(
            """
               select * from dbo.WildIsland where tag = :tag AND islandId = :id
            """
        )
            .bind("tag", tag)
            .bind("id", islandId)
            .mapTo<WildIslandDBModel>()
            .singleOrNull()
            ?.toWildIsland()

        if (wildIsland != null) return wildIsland

        return handle.createQuery(
            """
               select * from dbo.OwnedIsland where tag = :tag AND islandId = :id
            """
        )
            .bind("tag", tag)
            .bind("id", islandId)
            .mapTo<OwnedIslandDBModel>()
            .singleOrNull()
            ?.toOwnedIsland()
    }

    override fun getAll(tag: String): List<Island> {
        logger.info("Getting all island's from db with tag = {}", tag)

        val wildIslands = handle.createQuery(
            """
               select * from dbo.WildIsland where tag = :tag
            """
        )
            .bind("tag", tag)
            .mapTo<WildIslandDBModel>()
            .map { it.toWildIsland() }
            .list()

        val ownedIslands = handle.createQuery(
            """
               select * from dbo.OwnedIsland where tag = :tag
            """
        )
            .bind("tag", tag)
            .mapTo<OwnedIslandDBModel>()
            .map { it.toOwnedIsland() }
            .list()

        return wildIslands + ownedIslands
    }

    override fun create(tag: String, origin: Vector2, radius: Int) {
        logger.info("Creating island on game with tag = {}", tag)

        handle.createUpdate(
            """
                insert into dbo.WildIsland(tag, x, y, radius) values(:tag, :x, :y, :radius)
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
               DELETE FROM dbo.WildIsland WHERE tag = :tag AND islandId = :id
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