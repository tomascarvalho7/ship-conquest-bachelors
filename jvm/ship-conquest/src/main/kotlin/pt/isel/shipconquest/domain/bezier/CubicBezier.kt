package com.example.shipconquest.domain.bezier

import com.example.shipconquest.domain.space.Vector2
import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.space.toPosition
import kotlin.math.pow

/**
 * Represents a Bézier curve defined by four points, [p0] being the
 * starting position and [p3] the last.
 *
 * The interpolation value of this class is the variable *T*.
 */
class CubicBezier(val p0: Vector2, val p1: Vector2, val p2: Vector2, val p3: Vector2) {

    /**
     * Calculates an intermediate position along the [CubicBezier] based on an
     * [t] interpolation value.
     */
    fun get(t: Double): Position {
        // clamp value if [n] is out of bounds
        if (t <= 0) return p0.toPosition()
        if (t >= 1) return p3.toPosition()

        val _n = 1.0 - t
        val _n2 = _n.pow(2)
        val _n3 = _n2 * _n
        val n2 = t.pow(2)
        val n3 = n2 * t
        // formula:
        // P(t) = (1 - t)^3 * P1 + 3 * (1 - t)^2 * t * P2 + 3 * (1 - t) * t^2 * P3 + t^3 * P4
        return Position(
            x = _n3 * p0.x + 3 * _n2 * t * p1.x + 3 * _n * n2 * p2.x + n3 * p3.x,
            y = _n3 * p0.y + 3 * _n2 * t * p1.y + 3 * _n * n2 * p2.y + n3 * p3.y
        )
    }
}