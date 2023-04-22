package com.example.shipconquest.domain.path_finding

import com.example.shipconquest.domain.Vector2

fun main() {
    val testMap = generateSquare(10, 11, 10) + generateSquare(10, 21, 10) + generateSquare(19, 1, 10) + generateSquare(2, 31, 10) + generateSquare(2, 31, 5)

    val start = Vector2(0, 0)
    val end = Vector2(500, 500)
    val influencePoint = Vector2(0, 69)

    val shortestPath = findShortestPath(testMap, start, end, influencePoint, 1, 500)
    val middlePoints = defineMiddlePoints(shortestPath, 10)

    //printGrid(shortestPath, testMap, middlePoints, start, end, influencePoint, 500)
}

/**
 * Testing functions
 */

fun generateSquare(x: Int, y: Int, size: Int): List<Vector2> {
    val positions = mutableListOf<Vector2>()
    for (i in 0 until size) {
        for (j in 0 until size) {
            val newX = x + i
            val newY = y + j
            positions.add(Vector2(newX, newY))
        }
    }
    return positions
}

fun printGrid(
    path: List<Vector2>,
    barriers: List<Vector2>,
    middlePoints: List<Vector2>,
    start: Vector2,
    end: Vector2,
    influencePoint: Vector2,
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