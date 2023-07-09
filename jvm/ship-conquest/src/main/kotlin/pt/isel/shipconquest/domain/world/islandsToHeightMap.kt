package pt.isel.shipconquest.domain.world

import pt.isel.shipconquest.domain.space.Vector2
import pt.isel.shipconquest.domain.space.Vector3


fun islandsToHeightMap(islands: List<Vector3>, size: Int) = HeightMap(
    size = size,
    data = islands.associate { coord -> Vector2(x = coord.x, y = coord.y) to coord.z }
)