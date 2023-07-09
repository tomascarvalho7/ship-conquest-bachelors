package pt.isel.shipconquest.controller.model.input

import com.example.shipconquest.domain.space.Vector2

data class Vector2InputModel(val x: Int, val y: Int)

fun Vector2InputModel.toVector2() = Vector2(x = x, y = y)