package pt.isel.shipconquest.domain.space

import com.example.shipconquest.domain.Position
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import kotlin.math.sqrt

class Vector2Tests {
    @Test
    fun testPlus() {
        val vector1 = Vector2(x = 2, y = 3)
        val vector2 = Vector2(x = 1, y = 2)
        val expected = Vector2(x = 3, y = 5)
        val result = vector1 + vector2
        assertEquals(expected, result)
    }

    @Test
    fun testMinus() {
        val vector1 = Vector2(x = 2, y = 3)
        val vector2 = Vector2(x = 1, y = 2)
        val expected = Vector2(x = 1, y = 1)
        val result = vector1 - vector2
        assertEquals(expected, result)
    }

    @Test
    fun testToPosition() {
        val vector = Vector2(x = 2, y = 3)
        val expected = Position(2.0, 3.0)
        val result = vector.toPosition()
        assertEquals(expected, result)
    }

    @Test
    fun testDistanceTo() {
        val vector1 = Vector2(x = 2, y = 3)
        val vector2 = Vector2(x = 1, y = 2)
        val expected = sqrt(2.0)
        val result = vector1.distanceTo(vector2)
        assertEquals(expected, result, 0.0001)
    }
}