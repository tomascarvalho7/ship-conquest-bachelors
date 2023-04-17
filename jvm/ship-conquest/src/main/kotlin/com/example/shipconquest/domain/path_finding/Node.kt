package com.example.shipconquest.domain.path_finding

import com.example.shipconquest.domain.Coord2D

data class Node(
    val position: Coord2D,
    val f: Double = 0.0,
    val g: Double = 0.0,
    val h: Double = 0.0,
    val parent: Node? = null
)