package pt.isel.shipconquest.domain.world.islands

import pt.isel.shipconquest.domain.space.Vector2
import pt.isel.shipconquest.domain.space.distanceTo


fun getNearIslands(coordinate: Vector2, islands: List<Island>) =
    islands
        .filter { island -> canSightIsland(coordinate, island) }

fun canSightIsland(coordinate: Vector2, island: Island) =
    coordinate.distanceTo(island.coordinate) <= island.radius * 1.25