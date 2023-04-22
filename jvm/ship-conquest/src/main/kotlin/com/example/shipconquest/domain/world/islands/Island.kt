package com.example.shipconquest.domain.world.islands

import com.example.shipconquest.domain.Vector2

interface Island {
    val coordinate: Vector2
    val radius: Int
}