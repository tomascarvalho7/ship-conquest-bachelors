package com.example.shipconquest.domain.ship_navigation

import com.example.shipconquest.domain.Position

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
        val neighbors = calculateNeighbours(currNode, map, safetyRadius, mapSize, exploredNodes)

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
                val existingNode = foundNodes.find { node -> node.position == copyNode.position }
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