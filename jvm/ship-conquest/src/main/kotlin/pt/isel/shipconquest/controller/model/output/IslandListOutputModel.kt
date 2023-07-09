package pt.isel.shipconquest.controller.model.output

import pt.isel.shipconquest.controller.model.output.islands.IslandOutputModel
import pt.isel.shipconquest.controller.model.output.islands.toIslandOutputModel
import pt.isel.shipconquest.domain.world.islands.IslandList


data class IslandListOutputModel(val islands: List<IslandOutputModel>)

fun IslandList.toIslandListOutputModel() =
    IslandListOutputModel(islands = islands.map { it.toIslandOutputModel() })