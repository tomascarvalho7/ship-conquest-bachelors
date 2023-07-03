package com.example.shipconquest.controller.model.input

import com.example.shipconquest.domain.path_builder.PathPoints

data class NavigationPathInputModel(
    val start: Vector2InputModel,
    val mid: Vector2InputModel,
    val end: Vector2InputModel
)

fun NavigationPathInputModel.toPathPoints() =
    PathPoints(start = start.toVector2(), mid = mid.toVector2(), end = end.toVector2())