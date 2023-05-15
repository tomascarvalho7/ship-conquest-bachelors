package com.example.shipconquest.domain.world.islands

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.distanceTo

fun getNearIslands(coordinate: Vector2, islands: List<Island>) =
    islands
        .filter { island -> canSightIsland(coordinate, island) }

fun canSightIsland(coordinate: Vector2, island: Island) =
    coordinate.distanceTo(island.coordinate) <= island.radius // was / 1.5