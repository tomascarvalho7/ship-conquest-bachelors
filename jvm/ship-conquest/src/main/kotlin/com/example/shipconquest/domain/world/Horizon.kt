package com.example.shipconquest.domain.world

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.Vector3
import com.example.shipconquest.domain.world.islands.Island

data class Horizon(val tiles: List<Vector3>, val islands: List<Island>)