package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.WildIsland

data class IslandDBModel(
    val tag: String,
    val islandId: Int,
    val x: Int,
    val y: Int,
    val radius: Int,
    val incomePerHour: Int?,
    val uid: String?
)
fun IslandDBModel.toIsland(): Island {
    return if (incomePerHour != null && uid != null) {
        OwnedIsland(
            islandId = islandId,
            coordinate = Vector2(x = x, y = y),
            radius = radius,
            incomePerHour = incomePerHour,
            uid = uid
        )
    } else {
        WildIsland(islandId = islandId, coordinate = Vector2(x = x, y = y), radius = radius)
    }
}