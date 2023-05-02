package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.world.islands.WildIsland

data class WildIslandDBModel(
    val islandId: Int,
    val tag: String,
    val x: Int,
    val y: Int,
    val radius: Int
)

fun WildIslandDBModel.toWildIsland() =
    WildIsland(
        islandId = islandId,
        coordinate = Vector2(x = x, y = y),
        radius = radius
    )