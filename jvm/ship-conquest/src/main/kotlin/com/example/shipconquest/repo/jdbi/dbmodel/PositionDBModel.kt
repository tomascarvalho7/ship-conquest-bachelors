package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Position

data class PositionDBModel(val x: Int, val y: Int)

fun Position.toPositionDBModel(): PositionDBModel {
    return PositionDBModel(x, y)
}

fun Array<PositionDBModel>.toPositionList(): List<Position> {
    return map { position ->
        Position(position.x, position.y)
    }
}