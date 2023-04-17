package com.example.shipconquest.domain.path_finding

import com.example.shipconquest.domain.Coord2D

/**
 *  Using the A* algorithm, find the shortest path avoiding the existing isles and using the influence point to modify the result
 *  @param start the starting point
 *  @param end the end point
 *  @param influencePoint the point to influence the path
 *  @return list of positions with the full path
 */
fun findShortestPath(
    map: List<Coord2D>,
    start: Coord2D,
    end: Coord2D,
    influencePoint: Coord2D,
    safetyRadius: Int,
    mapSize: Int
): List<Coord2D> {
    val startH = calculateHeuristic(start, end, influencePoint)
    val startNode = Node(position = start, h = startH, f = startH)
    val foundNodes = mutableSetOf(startNode)
    val exploredNodes = HashMap<Int, Node>()// mutableSetOf<Node>()

    while (foundNodes.isNotEmpty()) {
        val currNode = foundNodes.minByOrNull { node -> node.f }
            ?: return emptyList() //find the one with the least f
        if (currNode.position == end) {
            return reconstructPath(currNode)
        }
        foundNodes.remove(currNode) //remove the node from the list
        exploredNodes[exploredNodes.size + 1] = currNode
        val neighbors = calculateNeighbours(currNode, map, safetyRadius, mapSize, exploredNodes)

        for (currNeighbour in neighbors) {
            if (currNeighbour in exploredNodes.values) {
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