package com.example.shipconquest.domain.path_finding

import com.example.shipconquest.domain.Vector2

data class Node(
    val position: Vector2,
    val f: Double = 0.0,
    val g: Double = 0.0,
    val h: Double = 0.0,
    val parent: Node? = null
)