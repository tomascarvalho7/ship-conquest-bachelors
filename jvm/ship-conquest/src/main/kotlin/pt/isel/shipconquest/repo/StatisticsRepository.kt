package pt.isel.shipconquest.repo

import org.slf4j.Logger
import pt.isel.shipconquest.domain.user.statistics.PlayerStatsBuilder
import java.time.Instant

interface StatisticsRepository {
    val logger: Logger
    fun createPlayerStats(tag: String, uid: String, initialCurrency: Int)
    fun getPlayerStats(tag: String, uid: String): PlayerStatsBuilder?
    fun updatePlayerCurrency(tag: String, uid: String, instant: Instant, newStaticCurrency: Int)
}