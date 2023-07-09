package pt.isel.shipconquest.domain.bezier.utils

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.bezier.CubicBezier
import com.example.shipconquest.domain.toVector2

/**
 * [CubicBezier] extension function to generate a list of points with length
 * of [numPoints] by sampling the curve.
 *
 * Note: A higher value of [numPoints] leads to a more accurate representation.
 */
fun CubicBezier.sample(numPoints: Int): List<Position> {
    val stepSize = 1.0 / (numPoints - 1)
    return (0 until numPoints).map { i -> get(i * stepSize) }
}

/**
 * [CubicBezier] extension function to split the curve
 * into a new [CubicBezier] segment from the [start] to [end] interpolation value.
 */
fun CubicBezier.split(start: Double, end: Double): CubicBezier {
    val segmentLength = end - start
    val t1 = (start + segmentLength / 3)
    val t2 = (start + 2 * segmentLength / 3)

    return CubicBezier(
        get(start).toVector2(),
        get(t1).toVector2(),
        get(t2).toVector2(),
        get(end).toVector2()
    )
}

/**
 * Function to convert a [CubicBezier] list into a [Vector2] list,
 * with four [Vector2] elements for every [CubicBezier] element.
 */
fun List<CubicBezier>.toVector2List() = flatMap {
    listOf(it.p0, it.p1, it.p2, it.p3)
}