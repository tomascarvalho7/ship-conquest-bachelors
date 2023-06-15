package com.example.shipconquest.domain.bezier

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.bezier.utils.split
import com.example.shipconquest.domain.space.toPosition
import com.example.shipconquest.domain.toVector2

class BezierSpline(
    val segments: List<CubicBezier>,
) {
    fun getPosition(u: Double): Position {
        val index = u.toInt()
        if (index >= segments.size) return segments.last().p3.toPosition()

        val n = u % 1
        return segments[index].get(n)
    }

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

    fun getFinalCoord() = getPosition(segments.size * 1.0).toVector2()
}