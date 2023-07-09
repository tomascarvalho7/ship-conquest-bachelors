package pt.isel.shipconquest.domain.world

import pt.isel.shipconquest.domain.space.Vector2
import java.util.HashMap

/**
 * The [HeightMapBuilder] class is the builder class for the immutable [HeightMap] class.
 * Includes a mutable implementation of the [HeightMap] class.
 */
class HeightMapBuilder(val size: Int) {
    private val hashMap = HashMap<Vector2, Int>()

    fun add(x: Int, y: Int, height: Int) {
        hashMap[Vector2(x = x, y = y)] = height
    }

    fun build(builderFn: (builder: HeightMapBuilder) -> Unit): HeightMap {
        builderFn(this) // build mutable instance of height map
        return HeightMap(data = hashMap.toMap(), size = size) // build immutable instance of heightmap from mutable instance
    }
}