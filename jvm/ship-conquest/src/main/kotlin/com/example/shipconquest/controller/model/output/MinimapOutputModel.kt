package com.example.shipconquest.controller.model.output

import com.example.shipconquest.domain.Minimap

data class MinimapOutputModel(val paths: List<Vector2OutputModel>, val islands: List<Vector3OutputModel>, val size: Int)

fun Minimap.toOutputModel() = MinimapOutputModel(
    paths = paths.map { it.toVector2OutputModel() },
    islands = islands.map { it.toVector3OutputModel() },
    size = size
)