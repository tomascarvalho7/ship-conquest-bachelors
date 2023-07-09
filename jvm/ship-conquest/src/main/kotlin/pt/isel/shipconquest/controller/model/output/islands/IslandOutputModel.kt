package pt.isel.shipconquest.controller.model.output.islands

import com.example.shipconquest.controller.model.output.Vector2OutputModel
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.WildIsland

interface IslandOutputModel {
    val id: Int
    val origin: Vector2OutputModel
    val radius: Int
}

fun Island.toIslandOutputModel() =
    when(this) {
        is WildIsland -> this.toWildIslandOutputModel()
        is OwnedIsland -> this.toOwnedIslandOutputModel()
    }