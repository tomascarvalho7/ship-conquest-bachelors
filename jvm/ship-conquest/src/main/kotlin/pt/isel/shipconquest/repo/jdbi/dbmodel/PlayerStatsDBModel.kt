package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.user.statistics.IslandIncome
import com.example.shipconquest.domain.user.statistics.PlayerIncome
import com.example.shipconquest.domain.user.statistics.PlayerStatsBuilder

data class PlayerStatsDBModel(val tag: String, val uid: String, val staticCurrency: Int)

fun PlayerStatsDBModel.toPlayerStats(islandsIncome: List<IslandIncome>) =
    PlayerStatsBuilder(
        tag = tag,
        uid = uid,
        income = PlayerIncome(
            staticCurrency = staticCurrency,
            passiveIncome = islandsIncome
        )
    )