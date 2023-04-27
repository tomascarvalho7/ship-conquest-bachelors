package com.example.shipconquest.domain.world

import com.example.shipconquest.domain.Factor
import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.generators.Falloff
import com.example.shipconquest.domain.generators.SimplexNoise
import com.example.shipconquest.domain.generators.get
import kotlin.math.roundToInt


const val frequency = .1f
const val seaLevel = 2

class WorldGenerator(
    private val worldSize: Int
) {
    val islandSize = 30
    private val falloffGrid = Falloff.generateFalloffMap(islandSize)

    fun generateIslandCoordinates(
        islandDensity: Factor, // 0 a 100
    ): List<Vector2> {
        if (worldSize == 0) return emptyList()

        val numIslands = 3 // (worldSize / (101 - islandDensity.value)) / (islandSize * 2)
        val gridSize = worldSize / numIslands
        val offset = gridSize / 2

        return buildList {
            this.add(Vector2(x = 10, y = 10))
            for (y in 0 until numIslands) {
                for (x in 0 until numIslands) {
                    val position = Vector2(x = offset + x * gridSize, y = offset + y * gridSize)
                    val randomOffset = Vector2(
                        x = (-offset..offset).random(),
                        y = (-offset..offset).random()
                    )
                    this.add(position + randomOffset)
                }
            }
        }
    }

    fun generate(origins: List<Vector2>) =
        HeightMapBuilder(worldSize).build {
            for (origin in origins) {
                generateIslandTerrain(origin = origin, builder = it)
            }
        }

    private fun generateIslandTerrain(origin: Vector2, builder: HeightMapBuilder) {
        val noiseMap = SimplexNoise.generateSimplexNoise(islandSize, frequency)
        val offset = origin - Vector2(islandSize / 2, islandSize / 2)
        // apply falloff, scale noise
        for (y in 0 until islandSize) {
            for (x in 0 until islandSize) {
                val noiseValue = noiseMap.get(x = x, y = y)
                val falloffValue = 1 - falloffGrid.get(x = x, y = y)
                val value = remapNoiseValue(value =  noiseValue * falloffValue)

                if (value > seaLevel)
                    builder.add(x = offset.x + x, y = offset.y + y, height = value)
            }
        }
    }

    // in value is between -1 and 1 (float)
    // out value is between -100 and 100 (int)
    private fun remapNoiseValue(value: Float) = (value * 100).roundToInt()
}
