package com.example.shipconquest.repo

import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import org.slf4j.Logger

interface IslandRepository {
    val logger: Logger

    fun get(tag: String, islandId: Int): Island?
    fun getAll(tag: String): List<Island>
    fun create(tag: String, island: WildIsland)
    fun addOwnerToIsland(tag: String, uid: String, incomePerHour: Int, island: Island)
}