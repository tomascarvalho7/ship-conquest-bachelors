package com.example.shipconquest.domain.generators

/**
 * The [Grid] data class is a wrapper class for the [MutableList] class, to
 * add operations with the X and Y axis in mind.
 *
 * The contents inside the [MutableList] are interpreted like a group
 * of rows with length of [size].
 */
data class Grid<T>(val data: MutableList<T>, val size: Int)

fun <T> Grid<T>.get(x: Int, y: Int): T {
    return data[x + y * size]
}

fun <T> Grid<T>.add(x: Int, y: Int, value: T) {
    data.add(x + y * size, value)
}