package pt.isel.shipconquest.controller.model.output

import com.example.shipconquest.domain.user.statistics.PlayerStatistics

data class PlayerStatisticsOutputModel(val currency: Int, val maxCurrency: Int)

fun PlayerStatistics.toPlayerStatisticsOutputModel() =
    PlayerStatisticsOutputModel(
        currency = currency,
        maxCurrency = maxCurrency
    )