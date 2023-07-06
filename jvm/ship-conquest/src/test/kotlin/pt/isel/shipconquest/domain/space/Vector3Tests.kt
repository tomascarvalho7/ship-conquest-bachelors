package com.example.shipconquest.domain.space

import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNotEquals
import org.junit.jupiter.api.Test

class Vector3Tests {

    @Test
    fun testEquals() {
        val vector1 = Vector3(2, 3, 4)
        val vector2 = Vector3(2, 3, 4)
        assertEquals(vector1, vector2)
    }

    @Test
    fun testNotEquals() {
        val vector1 = Vector3(2, 3, 4)
        val vector2 = Vector3(5, 6, 7)
        assertNotEquals(vector1, vector2)
    }

    @Test
    fun testToString() {
        val vector = Vector3(2, 3, 4)
        assertEquals("Vector3(x=2, y=3, z=4)", vector.toString())
    }
}