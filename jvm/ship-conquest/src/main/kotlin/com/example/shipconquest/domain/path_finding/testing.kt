package com.example.shipconquest.domain.path_finding

import com.example.shipconquest.domain.Coord2D

fun main() {
    val testMap = generateSquare(10, 11, 10) + generateSquare(10, 21, 10) + generateSquare(19, 1, 10) + generateSquare(2, 31, 10) + generateSquare(2, 31, 5)

    val start = Coord2D(0, 0)
    val end = Coord2D(500, 500)
    val influencePoint = Coord2D(0, 69)

    val shortestPath = findShortestPath(testMap, start, end, influencePoint, 1, 500)
    val middlePoints = defineMiddlePoints(shortestPath, 10)

    //printGrid(shortestPath, testMap, middlePoints, start, end, influencePoint, 500)
}

/**
 * Testing functions
 */

fun generateSquare(x: Int, y: Int, size: Int): List<Coord2D> {
    val positions = mutableListOf<Coord2D>()
    for (i in 0 until size) {
        for (j in 0 until size) {
            val newX = x + i
            val newY = y + j
            positions.add(Coord2D(newX, newY))
        }
    }
    return positions
}

fun printGrid(
    path: List<Coord2D>,
    barriers: List<Coord2D>,
    middlePoints: List<Coord2D>,
    start: Coord2D,
    end: Coord2D,
    influencePoint: Coord2D,
    mapSize: Int
) {
    val grid = Array(mapSize * mapSize) { CharArray(mapSize * mapSize) }
    for (position in path) {
        grid[position.y][position.x] = 'P'
    }
    for (position in barriers) {
        grid[position.y][position.x] = 'B'
    }
    grid[start.y][start.x] = 'S'
    grid[end.y][end.x] = 'E'
    grid[influencePoint.y][influencePoint.x] = 'I'
    for (position in middlePoints) {
        grid[position.y][position.x] = 'M'
    }

    for (i in 0 until mapSize) {
        for (j in 0 until mapSize) {
            print(if (grid[i][j].isLetter()) " ${grid[i][j]} " else " _ ")
        }
        println()
    }
}