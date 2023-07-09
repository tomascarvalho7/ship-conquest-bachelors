package pt.isel.shipconquest.domain.space

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.distanceTo
import com.example.shipconquest.domain.toVector2
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test
import kotlin.math.sqrt

class PositionTests {
    @Test
    fun testPlus() {
        val position1 = Position(x = 2.5, y = 3.5)
        val position2 = Position(x = 1.5, y = 2.5)
        val expected = Position(x = 4.0, y = 6.0)
        val result = position1 + position2
        assertEquals(expected, result)
    }

    @Test
    fun testMinus() {
        val position1 = Position(x = 2.5, y = 3.5)
        val position2 = Position(x = 1.5, y = 2.5)
        val expected = Position(x = 1.0, y = 1.0)
        val result = position1 - position2
        assertEquals(expected, result)
    }

    @Test
    fun testTimes() {
        val position = Position(x = 2.5, y = 3.5)
        val scalar = 1.5
        val expected = Position(x = 3.75, y = 5.25)
        val result = position * scalar
        assertEquals(expected, result)
    }

    @Test
    fun testToVector2() {
        val position = Position(x = 2.5, y =3.5)
        val expected = Vector2(x = 2, y = 3)
        val result = position.toVector2()
        assertEquals(expected, result)
    }

    @Test
    fun testDistanceTo() {
        val position1 = Position(x = 2.5, y = 3.5)
        val position2 = Position(x = 1.5, y = 2.5)
        val expected = sqrt(2.0)
        val result = position1.distanceTo(position2)
        assertEquals(expected, result, 0.0001)
    }
}