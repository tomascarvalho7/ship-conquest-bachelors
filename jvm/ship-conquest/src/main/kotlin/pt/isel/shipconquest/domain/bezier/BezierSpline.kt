package com.example.shipconquest.domain.bezier

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.bezier.utils.split
import com.example.shipconquest.domain.space.toPosition
import com.example.shipconquest.domain.toVector2

/**
 * The [BezierSpline] class represents a group of combined [CubicBezier]'s to form
 * a continuous spline with *N* number of control points.
 *
 * The interpolation value changes from *T* variable to *U* variable:
 * - The *U* variable is between 0-[segments length] and represents the **global** interpolation value
 * between the entire spline;
 * - Meanwhile the *T* variable becomes the **local** interpolation value to each individual [CubicBezier].
 */
class BezierSpline(
    val segments: List<CubicBezier>,
) {
    // calculate intermediate position along the spline for a given interpolation value [u]
    fun getPosition(u: Double): Position {
        if (u < 0) return segments.first().p0.toPosition()
        if (u >= segments.size) return segments.last().p3.toPosition()

        val index = u.toInt()
        val n = u % 1
        return segments[index].get(n)
    }

    // split the spline at a given interpolation value [u]
    fun split(u: Double): BezierSpline {
        if(u >= segments.size) return this // redundant split

        val bezierList= mutableListOf<CubicBezier>() // mutable list of beziers
        // bezier index
        val index = u.toInt()
        // find the t for the desired instant in the right bezier
        val t = u - index

        for (i in 0 until index) {
            bezierList.add(segments[i]) // add cubic bezier to spline
        }
        // split last cubic bezier to be added
        if(t > 0) bezierList.add(segments[index].split(0.0, t))

        return BezierSpline(bezierList)
    }
}