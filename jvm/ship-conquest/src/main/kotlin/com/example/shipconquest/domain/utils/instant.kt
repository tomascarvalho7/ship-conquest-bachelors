package com.example.shipconquest.domain.utils

import java.time.Instant

/**
 * Extension function that returns the result of the condition: is instant between start & end.
 */
fun Instant.isBetween(start: Instant, end: Instant) =
    isBefore(end) && isAfter(start)