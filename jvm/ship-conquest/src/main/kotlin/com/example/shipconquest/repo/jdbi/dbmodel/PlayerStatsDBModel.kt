package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.user.statistics.PlayerStats

data class PlayerStatsDBModel(val tag: String, val uid: String, val currency: Int, val maxCurrency: Int)

fun PlayerStatsDBModel.toPlayerStats() =
    PlayerStats(tag = tag, uid = uid, currency = currency, maxCurrency = maxCurrency)