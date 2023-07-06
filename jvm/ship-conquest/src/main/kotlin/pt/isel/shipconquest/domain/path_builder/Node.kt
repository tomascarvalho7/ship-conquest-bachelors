package com.example.shipconquest.domain.path_builder

import com.example.shipconquest.domain.space.Vector2

/** Class holding the information of a [Node] to be used in A* algorithm.
 *
 * [position] the node's position;
 * [f] is the node's comparative value;
 * [g] is the node's distance to the starting node;
 * [h] is the node's heuristic value;
 * [parent] is the node's parent.
 */
data class Node(
    val position: Vector2,
    val f: Double = 0.0,
    val g: Double = 0.0,
    val h: Double = 0.0,
    val parent: Node? = null
)


/**
 * Function to update a node with new [g], [h] and [parent] values.
 *
 * Returns a new [Node] with the updated fields.
 */
fun Node.update(g: Double, h: Double, parent: Node) = Node(
    position = position,
    f = g + h,
    g = g,
    h = h,
    parent = parent
)