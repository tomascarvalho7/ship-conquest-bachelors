package pt.isel.shipconquest.repo.jdbi.dbmodel.island

import com.example.shipconquest.domain.space.Vector2
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