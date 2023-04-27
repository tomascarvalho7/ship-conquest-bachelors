package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.user.statistics.PlayerStats
import com.example.shipconquest.repo.StatisticsRepository
import com.example.shipconquest.repo.jdbi.dbmodel.PlayerStatsDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.toPlayerStats
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.slf4j.Logger
import org.slf4j.LoggerFactory

class StatisticsRepositoryJDBI(private val handle: Handle): StatisticsRepository {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)
    override fun createPlayerStats(tag: String, uid: String, initialStats: PlayerStats) {
        logger.info("Creating statistics for player with uid = {} on lobby with tag = {}", uid, tag)

        handle.createUpdate(
            """
                insert into dbo.PlayerStatistics(tag, uid, currency, maxCurrency) 
                values(:tag, :uid, :currency, :maxCurrency)
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .bind("currency", initialStats.currency)
            .bind("maxCurrency", initialStats.maxCurrency)
            .execute()
    }

    override fun getPlayerStats(tag: String, uid: String): PlayerStats? {
        logger.info("Getting statistics for player with uid = {} on lobby with tag = {}", uid, tag)

        return handle.createQuery(
            """
                select * from PlayerStatistics where tag = :tag and uid = :uid
            """
        )
            .bind("tag", tag)
            .bind("uid", uid)
            .mapTo<PlayerStatsDBModel>()
            .singleOrNull()
            ?.toPlayerStats()
    }

    override fun updatePlayerStats(tag: String, uid: String, stats: PlayerStats) {
        logger.info("Updating statistics for player with uid = {} on lobby with tag = {}", uid, tag)

        handle.createUpdate(
            """
                UPDATE dbo.PlayerStatistics 
                SET currency = :currency, maxCurrency = :maxCurrency
                WHERE tag = :tag and uid = :uid
            """
        )
            .bind("currency", stats.currency)
            .bind("maxCurrency", stats.maxCurrency)
            .bind("tag", tag)
            .bind("uid", uid)
            .execute()
    }
}