package com.example.shipconquest.repo

import com.example.shipconquest.domain.user.statistics.PlayerStatsBuilder
import org.slf4j.Logger
import java.time.Instant

interface StatisticsRepository {
    val logger: Logger
    fun createPlayerStats(tag: String, uid: String, initialCurrency: Int)
    fun getPlayerStats(tag: String, uid: String): PlayerStatsBuilder?
    fun updatePlayerCurrency(tag: String, uid: String, instant: Instant, newStaticCurrency: Int)
}