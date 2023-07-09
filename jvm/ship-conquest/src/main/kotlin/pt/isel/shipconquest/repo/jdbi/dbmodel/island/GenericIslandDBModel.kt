package pt.isel.shipconquest.repo.jdbi.dbmodel.island

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.OwnershipDetails
import com.example.shipconquest.domain.world.islands.WildIsland
import java.time.Instant

data class GenericIslandDBModel(
    val islandId: Int,
    val tag: String,
    val x: Int,
    val y: Int,
    val radius: Int,
    val incomePerHour: Int?,
    val instant: Instant?,
    val uid: String?,
    val username: String?
)

fun GenericIslandDBModel.toIsland(userId: String): Island {
    return if (incomePerHour != null && instant != null && uid != null && username != null)
        OwnedIsland(
            islandId = islandId,
            coordinate = Vector2(x = x, y = y),
            radius = radius,
            incomePerHour = incomePerHour,
            conquestDate = instant,
            uid = uid,
            ownershipDetails = OwnershipDetails(owned = uid == userId, username = username)
        )
    else
        WildIsland(
            islandId = islandId,
            coordinate = Vector2(x = x, y = y),
            radius = radius
        )
}