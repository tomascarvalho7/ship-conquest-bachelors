package com.example.shipconquest

import java.time.Instant

// Interface representing a clock
interface Clock {
    fun now(): Instant
}

object RealClock : Clock {
    // To only have second precision
    override fun now(): Instant = Instant.ofEpochSecond(Instant.now().epochSecond)
}
