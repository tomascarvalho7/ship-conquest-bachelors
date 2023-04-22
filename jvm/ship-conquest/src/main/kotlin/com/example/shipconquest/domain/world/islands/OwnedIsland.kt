package com.example.shipconquest.domain.world.islands

import com.example.shipconquest.domain.Vector2

data class OwnedIsland(
    override val coordinate: Vector2,
    override val radius: Int,
    val uid: String,
    val incomePerHour: Int,
): Island