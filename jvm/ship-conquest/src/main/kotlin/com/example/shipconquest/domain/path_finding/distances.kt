package com.example.shipconquest.domain.path_finding

import com.example.shipconquest.domain.Vector2
import kotlin.math.abs
import kotlin.math.sqrt

fun calculateEuclideanDistance(start: Vector2, end: Vector2): Double {
    val dx = start.x - end.x
    val dy = start.y - end.y
    return sqrt(abs(dx * dx + dy * dy).toDouble())
}

fun calculateManhattanDistance(start: Vector2, end: Vector2): Double {
    return abs(start.x - end.x) + abs(start.y - end.y).toDouble()
}