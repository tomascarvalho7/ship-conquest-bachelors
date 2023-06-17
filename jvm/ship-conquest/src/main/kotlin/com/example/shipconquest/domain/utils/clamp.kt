package com.example.shipconquest.domain.utils

import kotlin.math.max
import kotlin.math.min

/**
 * Clamp extension function for the Integer and Double data types.
 *
 * This function assures that the clamped value can not be bigger than [max]
 * and smaller than [min].
 */
fun Int.clamp(min: Int, max: Int) = max(a = min(a = this, b = max), b = min)

fun Double.clamp(min: Double, max: Double) = max(a = min(a = this, b = max), b = min)