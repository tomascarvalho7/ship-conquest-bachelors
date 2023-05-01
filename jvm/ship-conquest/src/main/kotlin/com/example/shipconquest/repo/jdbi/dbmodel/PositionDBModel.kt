package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.Vector2

data class PositionDBModel(val x: Int, val y: Int)

fun Vector2.toPositionDBModel(): PositionDBModel {
    return PositionDBModel(x, y)
}

fun PositionDBModel.toVector2(): Vector2 {
    return Vector2(x, y)
}

fun Array<PositionDBModel>.toPositionList(): List<Vector2> {
    return map { position ->
        Vector2(position.x, position.y)
    }
}