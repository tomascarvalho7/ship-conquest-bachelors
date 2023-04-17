package com.example.shipconquest.domain.path_finding

import com.example.shipconquest.domain.Coord2D

fun calculateHeuristic(currPoint: Coord2D, end: Coord2D, influencePoint: Coord2D): Double {
    val distance = calculateManhattanDistance(currPoint, end)
    val penalty = calculateManhattanDistance(currPoint, influencePoint) / 2
    return distance + penalty
}

fun reconstructPath(lastNode: Node): List<Coord2D> {
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
    map: List<Coord2D>,
    safetyRadius: Int,
    mapSize: Int,
    ignore: HashMap<Int, Node>
): List<Node> {
    val pos = node.position
    val resultList = mutableListOf<Node>()

    for (i in pos.x - 1..pos.x + 1) {
        for (j in pos.y - 1..pos.y + 1) {
            if (i < 0 || i > mapSize || j < 0 || j > mapSize) {
                continue
            }
            val currPos = Coord2D(i, j)
            val isSafe = map.none { pos ->
                calculateEuclideanDistance(
                    pos,
                    currPos
                ) <= safetyRadius
            } // calculate according to radius
            val shouldBeIgnored = ignore.any { node -> node.value.position == currPos }
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