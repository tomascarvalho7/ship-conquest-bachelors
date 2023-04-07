package com.example.shipconquest.domain.ship_navigation

import com.example.shipconquest.domain.Position

fun calculateHeuristic(currPoint: Position, end: Position, influencePoint: Position): Double {
    val distance = calculateManhattanDistance(currPoint, end)
    val penalty = calculateManhattanDistance(currPoint, influencePoint) /2
    return distance + penalty
}

fun reconstructPath(lastNode: Node): List<Position> {
    val path = mutableListOf<Node>()
    var node: Node? = lastNode
    while (node != null) {
        path.add(node)
        node = node.parent
    }
    return path.reversed().map { node -> node.position }
}

fun calculateNeighbours(
    node: Node,
    map: List<Position>,
    safetyRadius: Int,
    mapSize: Int,
    ignore: Set<Node>
): List<Node> {
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
            val shouldBeIgnored = ignore.any { node -> node.position == currPos }
            if (!shouldBeIgnored && isSafe && currPos != pos) {
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