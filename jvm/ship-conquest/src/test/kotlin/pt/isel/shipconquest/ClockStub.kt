package pt.isel.shipconquest

import java.time.Instant

class ClockStub: pt.isel.shipconquest.Clock {
    override fun now(): Instant = Instant.parse("2023-01-01T00:00:00Z")
}
