package com.example.shipconquest.domain.path_finding

import com.example.shipconquest.domain.Coord2D
import kotlin.math.abs
import kotlin.math.sqrt

fun calculateEuclideanDistance(start: Coord2D, end: Coord2D): Double {
    val dx = start.x - end.x
    val dy = start.y - end.y
    return sqrt(abs(dx * dx + dy * dy).toDouble())
}

fun calculateManhattanDistance(start: Coord2D, end: Coord2D): Double {
    return abs(start.x - end.x) + abs(start.y - end.y).toDouble()
}