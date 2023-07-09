package pt.isel.shipconquest.controller.model.output

import pt.isel.shipconquest.controller.model.output.islands.IslandOutputModel
import pt.isel.shipconquest.controller.model.output.islands.toIslandOutputModel
import pt.isel.shipconquest.domain.world.Horizon


data class HorizonOutputModel(val tiles: List<Vector3OutputModel>, val islands: List<IslandOutputModel>)

fun Horizon.toHorizonOutputModel() = HorizonOutputModel(
    tiles = voxels.map { it.toVector3OutputModel() },
    islands = islands.map { it.toIslandOutputModel() }
)