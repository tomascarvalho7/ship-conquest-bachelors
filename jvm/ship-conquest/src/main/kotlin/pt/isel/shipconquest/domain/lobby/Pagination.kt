package com.example.shipconquest.domain.lobby

/**
 * [Limit] data class holds the data for a limit with default parameter
 */
data class Limit(val value: Int = 10)

/**
 * [Skip] class holds the data for a skip value with default parameter
 */
data class Skip(val value: Int = 0)

// [Limit] builder function
fun Int?.toLimit(): Limit {
    if (this == null || this < 0) return Limit()

    return Limit(this)
}

// [Skip] builder function
fun Int?.toSkip(): Skip {
    if (this == null || this < 0) return Skip()

    return Skip(this)
}