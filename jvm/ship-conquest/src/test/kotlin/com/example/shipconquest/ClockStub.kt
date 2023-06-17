package com.example.shipconquest

import java.time.Instant

class ClockStub: Clock {
    override fun now(): Instant = Instant.parse("2023-01-01T00:00:00Z")
}
