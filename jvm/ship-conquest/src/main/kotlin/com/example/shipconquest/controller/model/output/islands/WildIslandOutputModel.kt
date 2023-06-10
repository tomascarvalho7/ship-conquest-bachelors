package com.example.shipconquest.controller.model.output.islands

import com.example.shipconquest.controller.model.output.Vector2OutputModel
import com.example.shipconquest.controller.model.output.toVector2OutputModel
import com.example.shipconquest.domain.world.islands.WildIsland

class WildIslandOutputModel(
    override val id: Int,
    override val origin: Vector2OutputModel,
    override val radius: Int
): IslandOutputModel

fun WildIsland.toWildIslandOutputModel() =
    WildIslandOutputModel(
        id = islandId,
        origin = coordinate.toVector2OutputModel(),
        radius = radius
    )