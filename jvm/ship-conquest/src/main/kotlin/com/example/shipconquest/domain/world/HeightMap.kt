package com.example.shipconquest.domain.world

import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.Vector3
import kotlin.math.*

data class HeightMap(val data: Map<Vector2, Int>, val size: Int)

/**
 * pulse elements inside a [HeightMap] inside a [origin] with a [radius]
 */
fun HeightMap.pulse(origin: Vector2, radius: Int): List<Vector3>  {
    return buildList {
        for(y in -radius..radius) {
            val yF = y.toFloat()
           for(x in -radius..radius) {
               val xF = x.toFloat()
               val distance = sqrt((xF).pow(2) + (yF).pow(2))

               if (radius / distance >= .95) {
                   val pos = origin + Vector2(x, y)
                   val z = data[pos]

                   if (z != null) {
                       // add vector3 containing height coordinates to list
                       add(element = Vector3(x = pos.x, y = pos.y, z = z))
                   }
               }
           }
        }
    }
}