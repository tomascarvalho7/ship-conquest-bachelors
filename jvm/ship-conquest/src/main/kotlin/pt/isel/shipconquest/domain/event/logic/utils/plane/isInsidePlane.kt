package com.example.shipconquest.domain.event.logic.utils.plane

import com.example.shipconquest.domain.Position

fun Position.isInsidePlane(plane: Plane): Boolean {
    val (a, b, c, d) = plane
    val elements = arrayOf(a, b, c, d)
    var windingNumber = 0
    for (i in 0 until 4) {
        val v1 = if (i == 0) a else elements[i - 1]
        val v2 = elements[i]
        if ((v1.y <= y && v2.y > y) || (v1.y > y && v2.y <= y)) {
            val vt = (y - v1.y) / (v2.y - v1.y)
            if (x < v1.x + vt * (v2.x - v1.x)) {
                windingNumber += 1
            }
        }
    }
    return windingNumber % 2 == 1
}