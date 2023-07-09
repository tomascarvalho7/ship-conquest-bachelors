package pt.isel.shipconquest.domain.world.islands

import pt.isel.shipconquest.domain.space.Vector2

sealed interface Island {
    val islandId: Int
    val coordinate: Vector2
    val radius: Int
}