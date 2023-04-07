package com.example.shipconquest.domain.ship_navigation

import com.example.shipconquest.domain.Position

data class Node(
    val position: Position,
    val f: Double = 0.0,
    val g: Double = 0.0,
    val h: Double = 0.0,
    val parent: Node? = null
)