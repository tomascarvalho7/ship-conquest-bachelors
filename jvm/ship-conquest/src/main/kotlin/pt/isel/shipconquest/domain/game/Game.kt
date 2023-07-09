package pt.isel.shipconquest.domain.game

import pt.isel.shipconquest.domain.world.HeightMap


/**
 * The [Game] data class holds the data for the game world.
 */
data class Game(val tag: String, val map: HeightMap)