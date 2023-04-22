package com.example.shipconquest.domain

import kotlin.math.pow
import kotlin.math.sqrt

data class Vector2(val x: Int, val y: Int) {
    operator fun plus(position: Vector2) =
        Vector2(x = this.x + position.x, y = this.y + position.y)

    operator fun minus(position: Vector2) =
        Vector2(x = this.x - position.x, y = this.y - position.y)
}

fun Vector2.toPosition(): Position = Position(x = this.x.toDouble(), y = this.y.toDouble())

fun Vector2.distanceTo(other: Vector2) =
    sqrt((x - other.x).toDouble().pow(2) + (y - other.y).toDouble().pow(2))