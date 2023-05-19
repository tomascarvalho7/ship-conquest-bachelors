package com.example.shipconquest.repo

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import org.slf4j.Logger

interface IslandRepository {
    val logger: Logger
    fun get(tag: String, islandId: Int): Island?
    fun getAll(tag: String): List<Island>
    fun getVisitedIslands(tag: String, uid: String): List<Island>
    fun getUnvisitedIslands(tag: String, uid: String): List<Island>
    fun create(tag: String, origin: Vector2, radius: Int)
    fun updateOwnedIsland(tag: String, island: OwnedIsland)
    fun wildToOwnedIsland(tag: String, island: OwnedIsland)
}