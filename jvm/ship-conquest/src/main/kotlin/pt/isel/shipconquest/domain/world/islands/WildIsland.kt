package pt.isel.shipconquest.domain.world.islands

import pt.isel.shipconquest.domain.space.Vector2


data class WildIsland(
    override val islandId: Int,
    override val coordinate: Vector2,
    override val radius: Int
) : Island