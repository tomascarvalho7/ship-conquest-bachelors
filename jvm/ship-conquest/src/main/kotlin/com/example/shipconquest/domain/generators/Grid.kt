package com.example.shipconquest.domain.generators

data class Grid<T>(val data: MutableList<T>, val size: Int)

fun <T> Grid<T>.get(x: Int, y: Int): T {
    return data[x + y * size]
}

fun <T> Grid<T>.add(x: Int, y: Int, value: T) {
    data.add(x + y * size, value)
}