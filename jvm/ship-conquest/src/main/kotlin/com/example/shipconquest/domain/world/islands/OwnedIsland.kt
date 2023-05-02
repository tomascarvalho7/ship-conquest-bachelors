package com.example.shipconquest.domain.world.islands

import com.example.shipconquest.domain.Vector2
import java.time.Instant

data class OwnedIsland(
    override val islandId: Int,
    override val coordinate: Vector2,
    override val radius: Int,
    val uid: String,
    val incomePerHour: Int,
    val conquestDate: Instant
): Island