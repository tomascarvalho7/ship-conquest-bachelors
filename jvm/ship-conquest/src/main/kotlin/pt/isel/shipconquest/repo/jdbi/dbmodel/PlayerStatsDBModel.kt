package pt.isel.shipconquest.repo.jdbi.dbmodel

import pt.isel.shipconquest.domain.user.statistics.IslandIncome
import pt.isel.shipconquest.domain.user.statistics.PlayerIncome
import pt.isel.shipconquest.domain.user.statistics.PlayerStatsBuilder


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