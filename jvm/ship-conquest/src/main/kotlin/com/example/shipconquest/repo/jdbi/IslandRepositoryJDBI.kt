package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.repo.IslandRepository
import com.example.shipconquest.repo.jdbi.dbmodel.IslandDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.toIsland
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
           .mapTo<IslandDBModel>()
           .singleOrNull()
           ?.toIsland()
    }

    override fun getAll(tag: String): List<Island> {
        logger.info("Getting all island's from db with tag = {}", tag)

        return handle.createQuery(
            """
               select * from dbo.Game where tag = :tag
            """
        )
            .bind("tag", tag)
            .mapTo<IslandDBModel>()
            .list()
            .map { it.toIsland() }
    }

    override fun create(tag: String, island: WildIsland) {
        logger.info("Creating island on game with tag = {}", tag)

        handle.createUpdate(
            """
                insert into dbo.Island(tag, x, y, radius) values(:tag, :x, :y, :radius)
            """
        )
            .bind("tag", tag)
            .bind("x", island.coordinate.x)
            .bind("y", island.coordinate.y)
            .bind("radius", island.radius)
            .execute()
    }

    override fun addOwnerToIsland(tag: String, islandId: Int, island: OwnedIsland) {
        logger.info("User now owns the island with id = {} on game with tag = {}", islandId, tag)


        handle.createUpdate(
            """
                UPDATE dbo.Island SET 
                incomePerHour = :incomePerHour
                uid = :uid
                WHERE tag = :tag AND islandId = :id
            """
        )
            .bind("tag", tag)
            .bind("id", islandId)
            .bind("incomePerHour", island.incomePerHour)
            .bind("uid", island.uid)
            .execute()
    }
}