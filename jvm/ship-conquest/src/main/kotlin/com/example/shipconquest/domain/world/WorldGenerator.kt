package com.example.shipconquest.domain.world

import com.example.shipconquest.domain.Factor
import com.example.shipconquest.domain.Coord2D
import com.example.shipconquest.domain.generators.Falloff
import com.example.shipconquest.domain.generators.SimplexNoise
import com.example.shipconquest.domain.generators.get
import kotlin.math.roundToInt

const val islandSize = 30
const val frequency = .1f

class WorldGenerator(private val worldSize: Int) {
    private val falloffGrid = Falloff.generateFalloffMap(islandSize)

    fun generate(islandDensity: Factor): HeightMap {
        val islandOrigins = generateIslandCoordinates(islandDensity)

        return HeightMapBuilder(worldSize).build {
            for (origin in islandOrigins) {
                generateIslandTerrain(origin = origin, builder = it)
            }
        }
    }

    private fun generateIslandCoordinates(
        islandDensity: Factor, // 0 a 100
    ): List<Coord2D> {
        if (worldSize == 0) return emptyList()

        val numIslands = 3 // (worldSize / (101 - islandDensity.value)) / (islandSize * 2)
        val gridSize = worldSize / numIslands
        val offset = gridSize / 2

        return buildList {
            this.add(Coord2D(x = 10, y = 10))
            for (y in 0 until numIslands) {
                for (x in 0 until numIslands) {
                    val position = Coord2D(x = offset + x * gridSize, y = offset + y * gridSize)
                    val randomOffset = Coord2D(
                        x = (-offset..offset).random(),
                        y = (-offset..offset).random()
                    )
                    this.add(position + randomOffset)
                }
            }
        }
    }

    private fun generateIslandTerrain(origin: Coord2D, builder: HeightMapBuilder) {
        val noiseMap = SimplexNoise.generateSimplexNoise(islandSize, frequency)
        val offset = origin - Coord2D(islandSize / 2, islandSize / 2)
        // apply falloff, scale noise
        for (y in 0 until islandSize) {
            for (x in 0 until islandSize) {
                val noiseValue = noiseMap.get(x = x, y = y)
                val falloffValue = 1 - falloffGrid.get(x = x, y = y)
                val value = remapNoiseValue(value =  noiseValue * falloffValue)

                if (value > 0)
                    builder.add(x = offset.x + x, y = offset.y + y, height = value)
            }
        }
    }

    // in value is between -1 and 1 (float)
    // out value is between -100 and 100 (int)
    private fun remapNoiseValue(value: Float) = (value * 100).roundToInt()
}
