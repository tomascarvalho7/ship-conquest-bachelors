package pt.isel.shipconquest.domain.generators

import pt.isel.shipconquest.domain.space.Vector2
import kotlin.math.sqrt

/**
 * Singleton generator to generate a 2D Simplex Noise texture.
 *
 * Inspired by: The https://github.com/jrenner/kotlin-voxel Simplex Noise implementation
 */
object SimplexNoise {
    private val grad3 = arrayOf(
        Grad(1.0, 1.0, 0.0), Grad(-1.0, 1.0, 0.0), Grad(1.0, -1.0, 0.0), Grad(-1.0, -1.0, 0.0),
        Grad(1.0, 0.0, 1.0), Grad(-1.0, 0.0, 1.0), Grad(1.0, 0.0, -1.0), Grad(-1.0, 0.0, -1.0),
        Grad(0.0, 1.0, 1.0), Grad(0.0, -1.0, 1.0), Grad(0.0, 1.0, -1.0), Grad(0.0, -1.0, -1.0)
    )

    // list of random numbers
    private val p = shortArrayOf(
        151, 160, 137, 91, 90, 15,
        131, 13, 201, 95, 96, 53, 194, 233, 7, 225, 140, 36, 103, 30, 69, 142, 8, 99, 37, 240, 21, 10, 23,
        190, 6, 148, 247, 120, 234, 75, 0, 26, 197, 62, 94, 252, 219, 203, 117, 35, 11, 32, 57, 177, 33,
        88, 237, 149, 56, 87, 174, 20, 125, 136, 171, 168, 68, 175, 74, 165, 71, 134, 139, 48, 27, 166,
        77, 146, 158, 231, 83, 111, 229, 122, 60, 211, 133, 230, 220, 105, 92, 41, 55, 46, 245, 40, 244,
        102, 143, 54, 65, 25, 63, 161, 1, 216, 80, 73, 209, 76, 132, 187, 208, 89, 18, 169, 200, 196,
        135, 130, 116, 188, 159, 86, 164, 100, 109, 198, 173, 186, 3, 64, 52, 217, 226, 250, 124, 123,
        5, 202, 38, 147, 118, 126, 255, 82, 85, 212, 207, 206, 59, 227, 47, 16, 58, 17, 182, 189, 28, 42,
        223, 183, 170, 213, 119, 248, 152, 2, 44, 154, 163, 70, 221, 153, 101, 155, 167, 43, 172, 9,
        129, 22, 39, 253, 19, 98, 108, 110, 79, 113, 224, 232, 178, 185, 112, 104, 218, 246, 97, 228,
        251, 34, 242, 193, 238, 210, 144, 12, 191, 179, 162, 241, 81, 51, 145, 235, 249, 14, 239, 107,
        49, 192, 214, 31, 181, 199, 106, 157, 184, 84, 204, 176, 115, 121, 50, 45, 127, 4, 150, 254,
        138, 236, 205, 93, 222, 114, 67, 29, 24, 72, 243, 141, 128, 195, 78, 66, 215, 61, 156, 180
    )

    // To remove the need for index wrapping, double the permutation table length
    private val perm = ShortArray(512)
    private val permMod12 = ShortArray(512)

    init {
        for (i in 0..511) {
            perm[i] = p[i and 255]
            permMod12[i] = (perm[i] % 12).toShort()
        }
    }

    // Skewing and un skewing factors for 2, 3, and 4 dimensions
    private val F2 = 0.5 * (sqrt(3.0) - 1.0)
    private val G2 = (3.0 - sqrt(3.0)) / 6.0

    // This method is a *lot* faster than using (int)Math.floor(x)
    private fun fastFloor(x: Double): Int {
        val xi = x.toInt()
        return if (x < xi) xi - 1 else xi
    }

    private fun dot(g: Grad, x: Double, y: Double): Double {
        return g.x * x + g.y * y
    }

    // 2D simplex noise point generator
    private fun noise(xin: Double, yin: Double): Double {
        val n0: Double
        val n1: Double
        val n2: Double // Noise contributions from the three corners
        // Skew the input space to determine which simplex cell we're in
        val s = (xin + yin) * F2 // Hairy factor for 2D
        val i = fastFloor(xin + s)
        val j = fastFloor(yin + s)
        val t = (i + j) * G2
        val X0 = i - t // Unskew the cell origin back to (x,y) space
        val Y0 = j - t
        val x0 = xin - X0 // The x,y distances from the cell origin
        val y0 = yin - Y0
        // For the 2D case, the simplex shape is an equilateral triangle.
        // Determine which simplex we are in.
        val i1: Int
        val j1: Int // Offsets for second (middle) corner of simplex in (i,j) coords
        if (x0 > y0) {
            i1 = 1
            j1 = 0
        } // lower triangle, XY order: (0,0)->(1,0)->(1,1)
        else {
            i1 = 0
            j1 = 1
        } // upper triangle, YX order: (0,0)->(0,1)->(1,1)
        // A step of (1,0) in (i,j) means a step of (1-c,-c) in (x,y), and
        // a step of (0,1) in (i,j) means a step of (-c,1-c) in (x,y), where
        // c = (3-sqrt(3))/6
        val x1 = x0 - i1 + G2 // Offsets for middle corner in (x,y) unskewed coords
        val y1 = y0 - j1 + G2
        val x2 = x0 - 1.0 + 2.0 * G2 // Offsets for last corner in (x,y) unskewed coords
        val y2 = y0 - 1.0 + 2.0 * G2
        // Work out the hashed gradient indices of the three simplex corners
        val ii = i and 255
        val jj = j and 255
        val gi0 = permMod12[ii + perm[jj]].toInt()
        val gi1 = permMod12[ii + i1 + perm[jj + j1]].toInt()
        val gi2 = permMod12[ii + 1 + perm[jj + 1]].toInt()
        // Calculate the contribution from the three corners
        var t0 = 0.5 - x0 * x0 - y0 * y0
        if (t0 < 0) n0 = 0.0 else {
            t0 *= t0
            n0 = t0 * t0 * dot(grad3[gi0], x0, y0) // (x,y) of grad3 used for 2D gradient
        }
        var t1 = 0.5 - x1 * x1 - y1 * y1
        if (t1 < 0) n1 = 0.0 else {
            t1 *= t1
            n1 = t1 * t1 * dot(grad3[gi1], x1, y1)
        }
        var t2 = 0.5 - x2 * x2 - y2 * y2
        if (t2 < 0) n2 = 0.0 else {
            t2 *= t2
            n2 = t2 * t2 * dot(grad3[gi2], x2, y2)
        }
        // Add contributions from each corner to get the final noise value.
        // The result is scaled to return values in the interval [-1,1].
        return 70.0 * (n0 + n1 + n2)
    }

    /**
     * Generator function to generate Simplex Noise texture with a width & height of the
     * given [size].
     * The [offset] value changes the space coordinates of the resulting texture, and the
     *  [frequency] value changes the frequency and thus the size of the resulting values.
     */
    fun generateSimplexNoise(
        size: Int,
        offset: Vector2,
        frequency: Double
    ): Grid<Double> {
        val noiseMap = Grid<Double>(data = mutableListOf(), size = size)

        var y = 0
        while (y < size) {
            var x = 0
            while (x < size) {
                val value = noise((x + offset.x) * frequency, (y + offset.y) * frequency)
                noiseMap.add(x = x, y = y, value = (value + 1) / 2) // generate values between 0 and 1
                x++
            }
            y++
        }

        return noiseMap
    }

    // Inner class to speed upp gradient computations
    // (array access is a lot slower than member access)
    private data class Grad(val x: Double, val y: Double, val z: Double)
}