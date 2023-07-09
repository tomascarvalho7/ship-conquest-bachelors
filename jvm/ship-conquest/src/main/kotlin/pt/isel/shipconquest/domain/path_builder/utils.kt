package com.example.shipconquest.domain.path_builder

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.world.HeightMap
import com.example.shipconquest.domain.world.get
import com.example.shipconquest.domain.world.pulse
import kotlin.math.abs

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

fun checkMinimapCoordinate(map: HeightMap, coord: Vector2) =
    coord.x in 0 until map.size && coord.y in 0 until map.size
    && map.get(coord.x, coord.y) == null

fun calculateNeighbours(
    node: Node,
    map: HeightMap,
    ignore: HashMap<Vector2, Node>,
    settings: PathBuilder.PathSettings
): List<Node> {
    val pos = node.position
    val resultList = mutableListOf<Node>()

    val step = settings.step
    val horizontal = listOf(pos.x - step, pos.x, pos.x + step)
    val vertical = listOf(pos.y - step, pos.y, pos.y + step)

    for (i in horizontal) {
        for (j in vertical) {
            val currPos = Vector2(i, j)
            if (!checkMinimapCoordinate(map, currPos)) continue
            // check if there are any blocks around current coordinate
            val isSafe = map.pulse(
                origin = currPos,
                radius = settings.radius,
                water = false
            ).isEmpty()
            val shouldBeIgnored = ignore[currPos] != null
            if (!shouldBeIgnored && isSafe && currPos != pos) {
                resultList.add(element = Node(position = currPos))
            }
        }
    }

    return resultList
}

fun calculateManhattanDistance(start: Vector2, end: Vector2): Double {
    return abs(start.x - end.x) + abs(start.y - end.y).toDouble()
}