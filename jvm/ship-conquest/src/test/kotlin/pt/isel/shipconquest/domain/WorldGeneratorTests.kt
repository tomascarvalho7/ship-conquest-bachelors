package pt.isel.shipconquest.domain

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.space.distanceTo
import com.example.shipconquest.domain.world.WorldGenerator
import com.example.shipconquest.domain.world.get
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertTrue
import org.junit.jupiter.api.Test

class WorldGeneratorTests {
    @Test
    fun `generate islands origins in empty map`() {
        val worldSize = 0
        val generator = WorldGenerator(worldSize)

        val islandDensity = Factor(50) // 50% density
        val coordinates = generator.generateIslandCoordinates(islandDensity)

        assertEquals(emptyList<Vector2>(), coordinates)
    }

    @Test
    fun `generate islands origins for small map`() {
        val worldSize = 100
        val islandSize = 25
        val generator = WorldGenerator(worldSize)

        val islandDensity = Factor(50) // 50% density
        val coordinates = generator.generateIslandCoordinates(islandDensity)

        // Check that the number of coordinates matches the expected number of islands
        val numIslands = 1
        assertEquals(numIslands, coordinates.size)

        // Check that all coordinates are within the valid range
        // and with minimum distance between each other
        for (coordinate in coordinates) {
            assertTrue(coordinates.any { coord -> coord.distanceTo(coordinate) <= islandSize })
            assertTrue(coordinate.x in 0 until worldSize)
            assertTrue(coordinate.y in 0 until worldSize)
        }
    }

    @Test
    fun `generate islands origins for small map with bigger density`() {
        val worldSize = 100
        val islandSize = 25
        val generator = WorldGenerator(worldSize)

        val islandDensity = Factor(100) // 50% density
        val coordinates = generator.generateIslandCoordinates(islandDensity)

        // Check that the number of coordinates is bigger than 1
        assertTrue(coordinates.size > 1)

        // Check that all coordinates are within the valid range
        // and with minimum distance between each other
        for (coordinate in coordinates) {
            assertTrue(coordinates.any { coord -> coord.distanceTo(coordinate) <= islandSize })
            assertTrue(coordinate.x in 0 until worldSize)
            assertTrue(coordinate.y in 0 until worldSize)
        }
    }

    @Test
    fun `generate islands origins for medium map`() {
        val worldSize = 300
        val islandSize = 25
        val generator = WorldGenerator(worldSize)

        val islandDensity = Factor(50) // 50% density
        val coordinates = generator.generateIslandCoordinates(islandDensity)

        // Check that the number of coordinates is bigger than 1
        val numIslands = 9
        assertEquals(numIslands, coordinates.size)

        // Check that all coordinates are within the valid range
        // and with minimum distance between each other
        for (coordinate in coordinates) {
            assertTrue(coordinates.any { coord -> coord.distanceTo(coordinate) <= islandSize })
            assertTrue(coordinate.x in 0 until worldSize)
            assertTrue(coordinate.y in 0 until worldSize)
        }
    }

    @Test
    fun testGenerate() {
        val worldSize = 100
        val generator = WorldGenerator(worldSize)

        val origins = listOf(Vector2(25, 25), Vector2(75, 75))
        val heightMap = generator.generate(origins)

        // Check that the size of the generated height map matches the world size
        assertEquals(worldSize, heightMap.size)

        // Check that all heights are within the valid range
        for (y in 0 until worldSize) {
            for (x in 0 until worldSize) {
                val height = heightMap.get(x, y) ?: continue
                assertTrue(height in -100..100)
            }
        }
    }
}