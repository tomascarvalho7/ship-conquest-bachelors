package pt.isel.shipconquest.repo.jdbi

import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import pt.isel.shipconquest.domain.user.statistics.PlayerStatsBuilder
import pt.isel.shipconquest.repo.StatisticsRepository
import pt.isel.shipconquest.repo.jdbi.dbmodel.PlayerStatsDBModel
import pt.isel.shipconquest.repo.jdbi.dbmodel.island.OwnedIslandDBModel
import pt.isel.shipconquest.repo.jdbi.dbmodel.island.toIslandIncome
import pt.isel.shipconquest.repo.jdbi.dbmodel.toPlayerStats
import java.time.Instant

class StatisticsRepositoryJDBI(private val handle: Handle): StatisticsRepository {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)
    override fun createPlayerStats(tag: String, uid: String, initialCurrency: Int) {
        logger.info("Creating statistics for player with uid = {} on lobby with tag = {}", uid, tag)

        handle.createUpdate(
            """
                insert into dbo.PlayerStatistics(tag, uid, staticCurrency) 
                values(:tag, :uid, :staticCurrency)
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("staticCurrency", initialCurrency)
            .execute()
    }

    override fun getPlayerStats(tag: String, uid: String): PlayerStatsBuilder? {
        logger.info("Getting statistics for player with uid = {} on lobby with tag = {}", uid, tag)

        val islandsIncome = handle.createQuery(
            """
                SELECT tag, islandid, x, y, radius, incomeperhour, uid, instant, username 
                FROM dbo.Ownedisland o INNER JOIN dbo.User u
                ON o.uid = u.id
                WHERE o.tag = :tag and o.uid = :uid
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<OwnedIslandDBModel>()
            .map { it.toIslandIncome() }
            .list()

        return handle.createQuery(
            """
                select * from dbo.PlayerStatistics where tag = :tag and uid = :uid
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<PlayerStatsDBModel>()
            .singleOrNull()
            ?.toPlayerStats(islandsIncome = islandsIncome)
    }

    override fun updatePlayerCurrency(tag: String, uid: String, instant: Instant, newStaticCurrency: Int) {
        logger.info("Updating statistics for player with uid = {} on lobby with tag = {}", uid, tag)

        handle.createUpdate(
            """
                UPDATE dbo.OwnedIsland
                SET instant = :instant
                WHERE tag = :tag and uid = :uid
            """
        )
            .bind("instant", instant.epochSecond)
            .bind("tag", tag)
            .bind("uid", uid)
            .execute()

        handle.createUpdate(
            """
                UPDATE dbo.PlayerStatistics 
                SET staticCurrency = :newCurrency
                WHERE tag = :tag and uid = :uid
            """
        )
            .bind("newCurrency", newStaticCurrency)
            .bind("tag", tag)
            .bind("uid", uid)
            .execute()
    }
}