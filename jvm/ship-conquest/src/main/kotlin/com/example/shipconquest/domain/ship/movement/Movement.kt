package com.example.shipconquest.domain.ship.movement

import com.example.shipconquest.domain.space.Vector2
import java.time.Instant

/**
 * The [Movement] sealed interface is an abstraction of different types of movement.
 * This interface serves as a contract for implementing specific movement behaviours.
 */
sealed interface Movement {
    // calculate the current coordinate of a movement at a given [Instant]
    fun getCoordinateFromInstant(instant: Instant): Vector2
}