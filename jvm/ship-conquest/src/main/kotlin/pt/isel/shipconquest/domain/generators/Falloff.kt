package pt.isel.shipconquest.domain.generators

import kotlin.math.floor
import kotlin.math.pow

/**
 * Singleton generator to generate a falloff noise texture.
 *
 * Inspired by: Sebastian Lague in the "Procedural Generation Series".
 */
object Falloff {
    // generate the texture with width and height of a given [size]
    fun generateFalloffMap(size: Int): Grid<Float> {
        val falloffMap = Grid<Float>(data = mutableListOf(), size = size)
        val halfSize = floor(size / 2f)
        val edgeSize = (halfSize.pow(2) * 2).pow(.5f)

        for (y in 0 until size) {
            for (x in 0 until size) {
                val distance = ((halfSize - x).pow(2) + (halfSize -y).pow(2)).pow(0.5f)
                falloffMap.add(x = x, y = y, value = evaluate(distance / edgeSize))
            }
        }

        return falloffMap
    }

    // handle the falloff shape
    private fun evaluate(value: Float): Float {
        val a = 3f
        val b = 1.4f

        return value.pow(a) / (value.pow(a) + (b - b * value).pow(a))
    }
}