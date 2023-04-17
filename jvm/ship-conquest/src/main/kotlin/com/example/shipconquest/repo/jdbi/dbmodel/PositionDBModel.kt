package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Coord2D

data class PositionDBModel(val x: Int, val y: Int)

fun Coord2D.toPositionDBModel(): PositionDBModel {
    return PositionDBModel(x, y)
}

fun PositionDBModel.toPosition(): Coord2D {
    return Coord2D(x, y)
}

fun Array<PositionDBModel>.toPositionList(): List<Coord2D> {
    return map { position ->
        Coord2D(position.x, position.y)
    }
}