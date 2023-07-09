package pt.isel.shipconquest.controller.model.output.islands

import pt.isel.shipconquest.controller.model.output.Vector2OutputModel
import pt.isel.shipconquest.domain.world.islands.Island
import pt.isel.shipconquest.domain.world.islands.OwnedIsland
import pt.isel.shipconquest.domain.world.islands.WildIsland


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