package com.example.shipconquest.repo.jdbi.dbmodel.island

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.WildIsland
import java.time.Instant

data class GenericIslandDBModel(
    val islandId: Int,
    val tag: String,
    val x: Int,
    val y: Int,
    val radius: Int,
    val incomePerHour: Int?,
    val instant: Instant?,
    val uid: String?
)

fun GenericIslandDBModel.toIsland(): Island {
    return if (incomePerHour != null && instant != null && uid != null)
        OwnedIsland(
            islandId = islandId,
            coordinate = Vector2(x = x, y = y),
            radius = radius,
            incomePerHour = incomePerHour,
            conquestDate = instant,
            uid = uid
        )
    else
        WildIsland(
            islandId = islandId,
            coordinate = Vector2(x = x, y = y),
            radius = radius
        )
}