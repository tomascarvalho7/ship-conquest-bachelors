package com.example.shipconquest.domain.ship_navigation

import com.example.shipconquest.domain.Position

fun main() {
    val testMap = generateSquare(10, 11, 10) + generateSquare(10, 21, 10) + generateSquare(19, 1, 10) + generateSquare(2, 31, 10) + generateSquare(2, 31, 5)

    val start = Position(0, 0)
    val end = Position(69, 69)
    val influencePoint = Position(0, 69)

    val shortestPath = findShortestPath(testMap, start, end, influencePoint, 1, 70)
    val middlePoints = defineMiddlePoints(shortestPath, 10)

    printGrid(shortestPath, testMap, middlePoints, start, end, influencePoint, 70)
}

/**
 * Testing functions
 */

fun generateSquare(x: Int, y: Int, size: Int): List<Position> {
    val positions = mutableListOf<Position>()
    for (i in 0 until size) {
        for (j in 0 until size) {
            val newX = x + i
            val newY = y + j
            positions.add(Position(newX, newY))
        }
    }
    return positions
}

fun printGrid(
    path: List<Position>,
    barriers: List<Position>,
    middlePoints: List<Position>,
    start: Position,
    end: Position,
    influencePoint: Position,
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