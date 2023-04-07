package com.example.shipconquest.domain.ship_navigation

import com.example.shipconquest.domain.Position
import kotlin.math.abs
import kotlin.math.sqrt

fun calculateEuclideanDistance(start: Position, end: Position): Double {
    val dx = start.x - end.x
    val dy = start.y - end.y
    return sqrt(abs(dx * dx + dy * dy).toDouble())
}

fun calculateManhattanDistance(start: Position, end: Position): Double {
    return abs(start.x - end.x) + abs(start.y - end.y).toDouble()
}