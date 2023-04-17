package com.example.shipconquest.domain

data class Coord2D(val x: Int, val y: Int) {
    operator fun plus(position: Coord2D) =
        Coord2D(x = this.x + position.x, y = this.y + position.y)

    operator fun minus(position: Coord2D) =
        Coord2D(x = this.x - position.x, y = this.y - position.y)
}

fun Coord2D.toPosition(): Position = Position(x = this.x.toDouble(), y = this.y.toDouble())