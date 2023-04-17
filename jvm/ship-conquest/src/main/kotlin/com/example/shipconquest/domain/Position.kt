package com.example.shipconquest.domain

data class Position(val x: Double, val y: Double) {
    operator fun plus(position: Position) =
        Position(x = this.x + position.x, y = this.y + position.y)

    operator fun minus(position: Position) =
        Position(x = this.x - position.x, y = this.y - position.y)

    operator fun times(scalar: Double) =
        Position(x = this.x * scalar, y = this.y * scalar)
}

fun Position.toCoord2D() =
    Coord2D(x.toInt(), y.toInt())
