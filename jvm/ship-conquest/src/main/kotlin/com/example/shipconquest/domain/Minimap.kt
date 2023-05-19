package com.example.shipconquest.domain

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.space.Vector3

data class Minimap(val paths: List<Vector2>, val islands: List<Vector3>, val size: Int)