package pt.isel.shipconquest.domain.world

import pt.isel.shipconquest.domain.space.Vector3
import pt.isel.shipconquest.domain.world.islands.Island


/**
 * The [Horizon] data class holds the data of a fragment from a world, composed
 * of [voxels] and [islands].
 */
data class Horizon(val voxels: List<Vector3>, val islands: List<Island>)