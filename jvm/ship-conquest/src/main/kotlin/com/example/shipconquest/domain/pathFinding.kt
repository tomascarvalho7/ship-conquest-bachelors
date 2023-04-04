package com.example.shipconquest.domain

import kotlin.math.abs
import kotlin.math.sqrt

data class Node(
    val position: Position,
    val f: Float = 0f,
    val g: Float = 0f,
    val h: Float = 0f,
    val parent: Node? = null
)

/**
 *  Using the A* algorithm, find the shortest path avoiding the existing isles and using the influence point to modify the result
 *  @param start the starting point
 *  @param end the end point
 *  @param influencePoint the point to influence the path
 *  @return list of positions with the full path
 */
fun findShortestPath(
    map: List<Position>,
    start: Position,
    end: Position,
    influencePoint: Position,
    safetyRadius: Int,
    mapSize: Int
): List<Position> {
    val startH = calculateHeuristic(start, end, influencePoint)
    val startNode = Node(position = start, h = startH, f = startH)
    val foundNodes = mutableSetOf(startNode)
    val exploredNodes = mutableSetOf<Node>()
    while (foundNodes.isNotEmpty()) {
        val currNode = foundNodes.minByOrNull { node -> node.f }
            ?: return emptyList() //find the one with the least f
        if (currNode.position == end) {
            return reconstructPath(currNode)
        }
        foundNodes.remove(currNode) //remove the node from the list
        exploredNodes.add(currNode)
        val neighbors = calculateNeighbours(currNode, map, safetyRadius, mapSize)

        for (currNeighbour in neighbors) {
            if (currNeighbour in exploredNodes) {
                continue
            }

            val tempG = currNode.g + calculateEuclideanDistance(currNode.position, currNeighbour.position)

            val neighbourNode = foundNodes.find { it.position == currNeighbour.position }
                ?: currNeighbour

            if (tempG < neighbourNode.g || currNeighbour !in foundNodes) {
                // calculate f by the sum of g and h
                val h = calculateHeuristic(currNeighbour.position, end, influencePoint)
                val copyNode = currNeighbour.copy(g = tempG, h = h, f = tempG + h, parent = currNode)

                //optimization to avoid node repetition with worse f value, reducing the size of the list
                val existingNode = foundNodes.find { neighbourNode.position == copyNode.position }
                if (existingNode != null) {
                    if (copyNode.f < existingNode.f) {
                        foundNodes.add(copyNode)
                        foundNodes.remove(existingNode)
                    }
                } else {
                    foundNodes.add(copyNode)
                }
            }
        }
    }
    return emptyList()
}

fun calculateHeuristic(currPoint: Position, end: Position, influencePoint: Position): Float {
    val distance = calculateEuclideanDistance(currPoint, end)
    val penalty = calculateEuclideanDistance(currPoint, influencePoint) / 2 //division to reduce penalty
    return distance + penalty
}

fun reconstructPath(node: Node): List<Position> {
    val path = mutableListOf<Node>()
    var node: Node? = node
    while (node != null) {
        path.add(node)
        node = node.parent
    }
    return path.reversed().map { node -> node.position }
}

/**
 * Define middle points in the path to prepare the usage of Bézier curves at equal distance
 * @param path the shortest path to be used
 * @param distance the desired distance between points
 * @return a list with the points of interest
 */
fun defineMiddlePoints(path: List<Position>, numPoints: Int): List<Position> {
    val extractedPoints = mutableListOf<Position>()
    val step = (path.size - 1).toDouble() / (numPoints - 1).toDouble()
    for (i in 0 until numPoints) {
        val index = (i * step).toInt()
        extractedPoints.add(path[index])
    }
    return extractedPoints
}

fun calculateNeighbours(node: Node, map: List<Position>, safetyRadius: Int, mapSize: Int): List<Node> {
    val pos = node.position
    val resultList = mutableListOf<Node>()

    for (i in pos.x - 1..pos.x + 1) {
        for (j in pos.y - 1..pos.y + 1) {
            if (i < 0 || i > mapSize || j < 0 || j > mapSize) {
                continue
            }
            val currPos = Position(i, j)
            val isSafe = map.none { pos ->
                calculateEuclideanDistance(
                    pos,
                    currPos
                ) <= safetyRadius
            } // calculate according to radius
            if (isSafe && currPos != pos) {
                resultList.add(
                    Node(
                        position = currPos
                    )
                )
            }
        }
    }

    return resultList
}

fun calculateEuclideanDistance(start: Position, end: Position): Float {
    val dx = start.x - end.x
    val dy = start.y - end.y
    return sqrt(abs(dx * dx + dy * dy).toFloat())
}

fun main() {
    val testMap = /*emptyList<Position>()*/generateSquare(10, 10, 10) + generateSquare(30, 15, 10) + generateSquare(35, 35, 10)

    val start = Position(0, 0)
    val end = Position(69, 69)
    val influencePoint = Position(15, 35)

    val shortestPath = findShortestPath(testMap, start, end, influencePoint, 5, 70)
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