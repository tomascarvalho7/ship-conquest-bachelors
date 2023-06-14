package com.example.shipconquest.domain.game

import com.example.shipconquest.domain.world.HeightMap

/**
 * The [Game] data class holds the data for the game world.
 */
data class Game(val tag: String, val map: HeightMap)