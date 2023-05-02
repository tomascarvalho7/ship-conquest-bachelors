package com.example.shipconquest.repo

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import org.slf4j.Logger
import java.time.Instant
import java.util.Date

interface IslandRepository {
    val logger: Logger
    fun get(tag: String, islandId: Int): Island?
    fun getAll(tag: String): List<Island>
    fun create(tag: String, origin: Vector2, radius: Int)
    fun updateOwnedIsland(tag: String, island: OwnedIsland)
    fun wildToOwnedIsland(tag: String, island: OwnedIsland)
}