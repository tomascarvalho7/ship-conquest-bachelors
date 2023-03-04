package com.example.shipconquest.domain.world

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.Vector3
import com.example.shipconquest.domain.plus
import kotlin.math.*

data class HeightMap(val data: Map<Position, Int>, val size: Int)

/**
 * pulse elements inside a [HeightMap] inside a [origin] with a [radius]
 */
fun HeightMap.pulse(origin: Position, radius: Int): List<Vector3>  {
    return buildList {
        // 0 < i < radius * 2
        for (i in 1 until radius * 2) {
            val y = abs(radius - i)
            val j = radius - y
            // -j < x < j
            for (x in (-j + 1) until j) {
                val pos = origin + Position(x, y)
                val z = data[pos]

                if (z != null) {
                    // add vector3 containing height coordinates to list
                    add(element = Vector3(x = pos.x, y = pos.y, z = z))
                }
            }
        }
    }
}