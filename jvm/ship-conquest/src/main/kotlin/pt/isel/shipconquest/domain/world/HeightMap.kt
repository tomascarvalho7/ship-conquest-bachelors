package pt.isel.shipconquest.domain.world

import pt.isel.shipconquest.domain.space.Vector2
import pt.isel.shipconquest.domain.space.Vector3
import kotlin.math.*

/**
 * The [HeightMap] class represents immutable a height map, which is a two-dimensional
 * data structure that stores elevation values for each coordinate.
 */
data class HeightMap(val data: Map<Vector2, Int>, val size: Int)

/**
 * read Value stored at key with [Vector2] equal to [x] and [y]
 */
fun HeightMap.get(x: Int, y: Int) = data[Vector2(x = x, y = y)]

/**
 * pulse elements inside a [HeightMap] inside a [origin] with a [radius]
 */
fun HeightMap.pulse(origin: Vector2, radius: Int, water: Boolean): List<Vector3>  {
    return buildList {
        for(y in -radius..radius) {
            val yF = y.toFloat()
           for(x in -radius..radius) {
               val xF = x.toFloat()
               val distance = sqrt((xF).pow(2) + (yF).pow(2))

               if (radius / distance >= .95) {
                   val pos = origin + Vector2(x, y)
                   val z = data[pos]
                   // add vector3 containing height coordinates to list
                   if (z != null) {
                       add(element = Vector3(x = pos.x, y = pos.y, z = z))
                   } else if (water) {
                       add(element = Vector3(x = pos.x, y = pos.y, z = 0))
                   }
               }
           }
        }
    }
}