package com.example.shipconquest.controller.model.output

import com.example.shipconquest.domain.Vector2

data class Vector2OutputModel(val x: Int, val y: Int)

fun Vector2.toVector2OutputModel() = Vector2OutputModel(x = x, y = y)