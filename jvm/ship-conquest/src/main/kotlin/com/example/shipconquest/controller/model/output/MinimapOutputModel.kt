package com.example.shipconquest.controller.model.output

import com.example.shipconquest.domain.Minimap

data class MinimapOutputModel(val points: List<Vector3OutputModel>, val size: Int)

fun Minimap.toOutputModel() = MinimapOutputModel(
    points = visitedPoints.map { it.toVector3OutputModel() },
    size = size
)