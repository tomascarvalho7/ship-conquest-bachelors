package pt.isel.shipconquest.controller.model.output

import pt.isel.shipconquest.domain.space.Vector2


data class Vector2OutputModel(val x: Int, val y: Int)

fun Vector2.toVector2OutputModel() = Vector2OutputModel(x = x, y = y)