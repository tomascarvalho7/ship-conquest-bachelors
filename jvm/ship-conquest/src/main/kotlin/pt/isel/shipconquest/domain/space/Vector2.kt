package pt.isel.shipconquest.domain.space

import com.example.shipconquest.domain.Position
import kotlin.math.pow
import kotlin.math.sqrt

/**
 * The Vector2 class represents a space in a 2D Grid with
 * the [x] and [y] axis.
 */
data class Vector2(val x: Int, val y: Int) {
    operator fun plus(position: Vector2) =
        Vector2(x = this.x + position.x, y = this.y + position.y)

    operator fun minus(position: Vector2) =
        Vector2(x = this.x - position.x, y = this.y - position.y)
}

fun Vector2.toPosition(): Position = Position(x = this.x.toDouble(), y = this.y.toDouble())

fun Vector2.distanceTo(other: Vector2) =
    sqrt((x - other.x).toDouble().pow(2) + (y - other.y).toDouble().pow(2))