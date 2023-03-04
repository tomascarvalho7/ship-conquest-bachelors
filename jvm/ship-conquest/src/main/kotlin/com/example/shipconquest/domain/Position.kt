package com.example.shipconquest.domain

data class Position(val x: Int, val y: Int)

operator fun Position.plus(position: Position) =
    Position(x = this.x + position.x, y = this.y + position.y)

operator fun Position.minus(position: Position) =
    Position(x = this.x - position.x, y = this.y - position.y)