package pt.isel.shipconquest.domain.minimap

import pt.isel.shipconquest.domain.space.Vector2
import pt.isel.shipconquest.domain.space.Vector3


/**
 * The [Minimap] data class holds the data of the travelled paths and visited islands.
 * This data is relevant to find the visited voxels by the player.
 */
data class Minimap(val paths: List<Vector2>, val islands: List<Vector3>, val size: Int)