package com.example.shipconquest.domain.ship_navigation.utils

data class Vector(val x: Double, val y: Double)

operator fun Vector.plus(other: Vector) =
    Vector(x + other.x, y + other.y)

operator fun Vector.times(other: Double) =
    Vector(x * other, y * other)

fun Vector.normalize(): Vector {
    val length = kotlin.math.sqrt(x * x + y * y)
    return Vector(x = x / length, y / length)
}

fun Vector.reverse() = Vector(x = -x, y = -y)