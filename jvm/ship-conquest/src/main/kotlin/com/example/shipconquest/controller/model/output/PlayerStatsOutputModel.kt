package com.example.shipconquest.controller.model.output

import com.example.shipconquest.domain.user.statistics.PlayerStats

data class PlayerStatsOutputModel(val tag: String, val uid: String, val currency: Int, val maxCurrency: Int)

fun PlayerStats.toPlayerStatsOutputModel() =
    PlayerStatsOutputModel(tag = tag, uid = uid, currency = currency, maxCurrency = maxCurrency)