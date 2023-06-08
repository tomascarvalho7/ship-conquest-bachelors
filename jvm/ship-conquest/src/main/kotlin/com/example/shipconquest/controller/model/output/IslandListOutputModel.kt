package com.example.shipconquest.controller.model.output

import com.example.shipconquest.domain.world.islands.IslandList

data class IslandListOutputModel(val islands: List<IslandOutputModel>)

fun IslandList.toIslandListOutputModel() =
    IslandListOutputModel(islands = islands.map { it.toIslandOutputModel() })