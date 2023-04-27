package com.example.shipconquest.domain.world.islands

import com.example.shipconquest.domain.Vector2

sealed interface Island {
    val islandId: Int
    val coordinate: Vector2
    val radius: Int
}