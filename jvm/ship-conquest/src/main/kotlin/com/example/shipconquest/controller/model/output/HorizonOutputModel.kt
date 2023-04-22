package com.example.shipconquest.controller.model.output

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.Vector3
import com.example.shipconquest.domain.world.Horizon

data class HorizonOutputModel(val tiles: List<Vector3>, val islands: List<Vector2>)

fun Horizon.toHorizonOutputModel() = HorizonOutputModel(tiles = tiles, islands = islands)