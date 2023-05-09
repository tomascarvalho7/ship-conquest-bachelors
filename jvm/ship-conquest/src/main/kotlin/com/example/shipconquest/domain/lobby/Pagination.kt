package com.example.shipconquest.domain.lobby

/**
 * Limit class with default parameter
 */
data class Limit(val value: Int = 10)

/**
 * Skip class with default parameter
 */
data class Skip(val value: Int = 0)

/**
 * [Int] to [Limit] function
 */
fun Int?.toLimit(): Limit {
    if (this == null || this < 0) return Limit()

    return Limit(this)
}

/**
 * [Int] to [Limit] function
 */
fun Int?.toSkip(): Skip {
    if (this == null || this < 0) return Skip()

    return Skip(this)
}