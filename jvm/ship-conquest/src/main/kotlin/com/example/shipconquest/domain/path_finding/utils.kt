package com.example.shipconquest.domain.path_finding

import com.example.shipconquest.domain.space.Vector2

fun calculateHeuristic(currPoint: Vector2, end: Vector2, influencePoint: Vector2): Double {
    val distance = calculateManhattanDistance(currPoint, end)
    val penalty = calculateManhattanDistance(currPoint, influencePoint) / 2
    return distance + penalty
}

fun reconstructPath(lastNode: Node): List<Vector2> {
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
    map: List<Vector2>,
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
            val currPos = Vector2(i, j)
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