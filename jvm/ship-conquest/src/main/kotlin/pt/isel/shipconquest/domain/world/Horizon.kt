package com.example.shipconquest.domain.world

import com.example.shipconquest.domain.space.Vector3
import com.example.shipconquest.domain.world.islands.Island

/**
 * The [Horizon] data class holds the data of a fragment from a world, composed
 * of [voxels] and [islands].
 */
data class Horizon(val voxels: List<Vector3>, val islands: List<Island>)