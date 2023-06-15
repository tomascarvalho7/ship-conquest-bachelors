package com.example.shipconquest.domain.utils

import java.time.Instant

fun Instant.isBetween(start: Instant, end: Instant) =
    isBefore(end) && isAfter(start)