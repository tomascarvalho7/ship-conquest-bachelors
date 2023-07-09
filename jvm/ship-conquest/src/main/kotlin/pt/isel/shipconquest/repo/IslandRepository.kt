package pt.isel.shipconquest.repo

import org.slf4j.Logger
import pt.isel.shipconquest.domain.space.Vector2
import pt.isel.shipconquest.domain.world.islands.Island
import pt.isel.shipconquest.domain.world.islands.OwnedIsland

interface IslandRepository {
    val logger: Logger
    fun get(tag: String, uid: String, islandId: Int): Island?
    fun getAll(tag: String, uid: String): List<Island>
    fun getVisitedIslands(tag: String, uid: String): List<Island>
    fun getUnvisitedIslands(tag: String, uid: String): List<Island>
    fun create(tag: String, origin: Vector2, radius: Int)
    fun updateOwnedIsland(tag: String, island: OwnedIsland)
    fun wildToOwnedIsland(tag: String, island: OwnedIsland)
}