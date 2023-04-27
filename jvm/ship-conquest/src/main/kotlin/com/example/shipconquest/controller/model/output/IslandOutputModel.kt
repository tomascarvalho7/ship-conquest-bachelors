package com.example.shipconquest.controller.model.output

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

class WildIslandOutputModel(
    override val id: Int,
    override val origin: Vector2OutputModel,
    override val radius: Int
): IslandOutputModel

class OwnedIslandOutputModel(
    override val id: Int,
    override val origin: Vector2OutputModel,
    override val radius: Int,
    val incomePerHour: Int,
    val uid: String
): IslandOutputModel

fun WildIsland.toWildIslandOutputModel() =
    WildIslandOutputModel(
        id = islandId,
        origin = coordinate.toVector2OutputModel(),
        radius = radius
    )

fun OwnedIsland.toOwnedIslandOutputModel() =
    OwnedIslandOutputModel(
        id = islandId,
        origin = coordinate.toVector2OutputModel(),
        radius = radius,
        incomePerHour = incomePerHour,
        uid = uid
    )