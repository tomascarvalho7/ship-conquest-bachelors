package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.user.statistics.IslandIncome
import com.example.shipconquest.domain.world.islands.OwnedIsland
import java.time.Instant

data class OwnedIslandDBModel(
    val tag: String,
    val islandId: Int,
    val x: Int,
    val y: Int,
    val radius: Int,
    val incomePerHour: Int,
    val instant: Instant,
    val uid: String
)

fun OwnedIslandDBModel.toOwnedIsland() =
    OwnedIsland(
        islandId = islandId,
        coordinate = Vector2(x = x, y = y),
        radius = radius,
        incomePerHour = incomePerHour,
        conquestDate = instant,
        uid = uid
    )

fun OwnedIslandDBModel.toIslandIncome() =
    IslandIncome(
        incomePerHour = incomePerHour,
        conquestDate = instant
    )