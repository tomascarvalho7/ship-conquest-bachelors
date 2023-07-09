package pt.isel.shipconquest.controller.model.output.islands

import com.example.shipconquest.controller.model.output.Vector2OutputModel
import com.example.shipconquest.controller.model.output.toVector2OutputModel
import com.example.shipconquest.domain.world.islands.OwnedIsland

class OwnedIslandOutputModel(
    override val id: Int,
    override val origin: Vector2OutputModel,
    override val radius: Int,
    val incomePerHour: Int,
    val username: String,
    val owned: Boolean
): IslandOutputModel

fun OwnedIsland.toOwnedIslandOutputModel() =
    OwnedIslandOutputModel(
        id = islandId,
        origin = coordinate.toVector2OutputModel(),
        radius = radius,
        incomePerHour = incomePerHour,
        username = ownershipDetails.username,
        owned = ownershipDetails.owned
    )