package com.example.shipconquest.domain.ship_navigation.utils

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.ship_navigation.Plane

fun Plane.isOverlapping(other: Plane): Boolean {
    val allNormals = getNormals() + other.getNormals()
    for (axis in allNormals) {
        val (minA, maxA) = getProjection(axis)
        val (minB, maxB) = other.getProjection(axis)
        if (!overlaps(Pair(minA, maxA), Pair(minB, maxB))) {
            return false
        }
    }
    return true
}

fun Plane.getNormals() = buildList {
    add(Position(x = -(b.y - a.y), y = b.x - a.x))
    add(Position(x = -(c.y - b.y), y = c.x - b.x))
    add(Position(x = -(d.y - c.y), y = d.x - c.x))
    add(Position(x = -(a.y - d.y), y = a.x - d.x))
}

private fun Plane.iterable() = listOf(a, b, c, d)

private fun Plane.getProjection(axis: Position): Pair<Double, Double> {
    var min = Double.POSITIVE_INFINITY
    var max = Double.NEGATIVE_INFINITY
    for (point in iterable()) {
        val dotProduct = axis.x * point.x + axis.y * point.y
        if (dotProduct < min) {
            min = dotProduct
        }
        if (dotProduct > max) {
            max = dotProduct
        }
    }
    return Pair(min, max)
}

private fun overlaps(a: Pair<Double, Double>, b: Pair<Double, Double>) =
    a.second >= b.first && b.second >= a.first