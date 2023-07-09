package pt.isel.shipconquest.domain.world.islands

import pt.isel.shipconquest.domain.space.Vector2
import java.time.Instant

data class OwnedIsland(
    override val islandId: Int,
    override val coordinate: Vector2,
    override val radius: Int,
    val uid: String,
    val incomePerHour: Int,
    val conquestDate: Instant,
    val ownershipDetails: OwnershipDetails
): Island