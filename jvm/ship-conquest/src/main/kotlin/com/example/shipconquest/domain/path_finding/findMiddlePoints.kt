package com.example.shipconquest.domain.path_finding

import com.example.shipconquest.domain.Coord2D


/**
 * Define middle points in the path to prepare the usage of Bézier curves at equal distance
 * @param path the shortest path to be used
 * @param distance the desired distance between points
 * @return a list with the points of interest
 */
fun defineMiddlePoints(path: List<Coord2D>, numPoints: Int): List<Coord2D> {
    val extractedPoints = mutableListOf<Coord2D>()
    val step = (path.size - 1).toDouble() / (numPoints - 1).toDouble()
    for (i in 0 until numPoints) {
        val index = (i * step).toInt()
        extractedPoints.add(path[index])
    }
    return extractedPoints
}
