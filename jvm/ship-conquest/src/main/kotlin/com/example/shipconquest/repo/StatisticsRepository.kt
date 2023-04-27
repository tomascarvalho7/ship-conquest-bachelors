package com.example.shipconquest.repo

import com.example.shipconquest.domain.user.statistics.PlayerStats
import org.slf4j.Logger

interface StatisticsRepository {
    val logger: Logger
    fun createPlayerStats(tag: String, uid: String, initialStats: PlayerStats)
    fun getPlayerStats(tag: String, uid: String): PlayerStats?
    fun updatePlayerStats(tag: String, uid: String, stats: PlayerStats)
}