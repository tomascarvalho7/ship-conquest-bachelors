package pt.isel.shipconquest.domain.path_builder

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.space.distanceTo
import com.example.shipconquest.domain.world.HeightMap
import kotlin.math.floor
import kotlin.math.roundToInt

/**
 * Singleton holding the logic to build & normalize a path in a 2D space
 *
 * The logic to find a path between point A and B (and the middle point) is a
 * custom implementation of the informed search algorithm A* with optimizations
 * and caveats only specific to this projects' context.
 */
object PathBuilder {
    /** Function to build a new path given a [map], a list of [points] and a set of [settings]
     *
     * Returns a list of coordinates containing the many steps of the calculated path.
     */
    fun build(map: HeightMap, points: PathPoints, settings: PathSettings): List<Vector2> {
        if (!checkMinimapCoordinate(map, points.end)) return emptyList()

        val newNodes = HashMap<Vector2, Node>() // map of nodes to be evaluated
        val oldNodes = HashMap<Vector2, Node>() // map of nodes already evaluated
        newNodes[points.start] = Node(position = points.start) // add the start node to newNodes

        var iterations = 0
        // keep searching until no more nodes are found, or maxIterations is reached.
        while (newNodes.isNotEmpty() || iterations == settings.maxIterations) {
            // get node with lowest f
            val current = newNodes.values.reduce { a, b -> if (a.f < b.f)  a else b}
            newNodes.remove(current.position) // remove from new nodes
            oldNodes[current.position] = current // add to old nodes


            // if distance is smaller than step, then path has been found
            if (current.position.distanceTo(points.end) <= settings.radius)
                return reconstructPath(Node(position = points.end, parent = current))

            // get current node neighbours
            val neighbours = calculateNeighbours(current, map, oldNodes, settings)
            for (node in neighbours) {
                val neighbour = node.update(
                    g = current.g + current.position.distanceTo(node.position),
                    h = calculateHeuristic(node.position, points.end, points.mid),
                    parent = current
                )
                // if shorter or not yet included, add current neighbour
                val oldNeighbour = newNodes[neighbour.position]
                if (oldNeighbour == null || neighbour.f < oldNeighbour.f)
                    newNodes[neighbour.position] = neighbour
                iterations++ // increment
            }
        }

        return emptyList()
    }

    // Function to normalize the given list of points according to the number
    // of Bézier curves [size].
    fun normalize(path: List<Vector2>, size: Int): List<Vector2> {
        if (path.isEmpty()) return emptyList()

        val length = size * 4
        val step = kotlin.math.ceil((path.size - 1.0) / (length - 1.0))

        return List(length) { index ->
            if (index == 0) return@List path[0]

            val offset = floor(index / 4.0)

            return@List path[kotlin.math.min(((index - offset) * step).roundToInt(), path.size - 1)]
        }
    }

    /**
     * methods to build a [PathSettings] class instance
     */
    fun defaultSettings() = PathSettings(10, 9, 250)
    fun customSettings(step: Int, radius: Int, maxIterations: Int) =
        PathSettings(step, radius, maxIterations)
    data class PathSettings(val step: Int, val radius: Int, val maxIterations: Int)
}