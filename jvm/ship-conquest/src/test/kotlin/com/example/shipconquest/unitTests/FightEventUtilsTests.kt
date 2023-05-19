package com.example.shipconquest.unitTests

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.event.logic.utils.comparePoints
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Test

class FightEventUtilsTests {
    @Test
    fun comparePointsTest() {
        val points = listOf(
            Position(0.0, 0.0),
            Position(1.0, 0.0), // closest point
            Position(2.0, 0.0),
            Position(3.0, 0.0)
        )

        val otherPoints = listOf(
            Position(-1.0, 0.0),
            Position(-0.5, 0.0),
            Position(1.0, 0.0), // closest point
            Position(4.0, 0.0)
        )

        // return index of the closest point
        val closestIndex = comparePoints(points, otherPoints)
        val index = 1.0
        assertEquals(index / points.size, closestIndex)
    }

    @Test
    fun comparePointsWithEmptyLists() {
        val points = emptyList<Position>()
        val otherPoints = emptyList<Position>()

        val closestIndex = comparePoints(points, otherPoints)

        val index = 0.0
        assertEquals(index, closestIndex)
    }

    @Test
    fun comparePointsWithDifferentSizes() {
        val points = listOf(
            Position(0.0, 0.0),
            Position(3.0, 0.0), // closest point
            Position(3.0, 2.0),
            Position(3.0, 4.0),
            Position(3.0, 1.0)
        )

        val otherPoints = listOf(
            Position(3.0, 0.0), // closest point
            Position(5.0, 0.0)
        )

        val closestIndex = comparePoints(points, otherPoints)
        val index = 1.0
        assertEquals(index / points.size, closestIndex)
    }

    @Test
    fun comparePointsBasedOnBestTime() {
        val points = listOf(
            Position(-1.0, 0.0),
            Position(0.0, 0.0),
            Position(1.0, 0.0), // same distance but closest time
            Position(2.0, 0.0),
            Position(1.0, 0.0)
        )

        val otherPoints = listOf(
            Position(3.0, 0.0),
            Position(2.0, 0.0),
            Position(1.0, 0.0), // same distance but closest time
            Position(0.0, 0.0),
            Position(2.0, 0.0)
        )

        // both lists have all points in common,
        // but the middle points are the closest at the same time !
        val closestIndex = comparePoints(points, otherPoints)
        val index = 2.0
        assertEquals(index / points.size, closestIndex)
    }

    @Test
    fun comparePointsBasedOnWorstTime() {
        val points = listOf(
            Position(0.0, 0.0), // closest point, worst time
            Position(2.0, 0.0), // not the closest point, best time
            Position(5.0, 0.0),
            Position(5.0, 0.0),
            Position(5.0, 0.0)
        )

        val otherPoints = listOf(
            Position(10.0, 0.0),
            Position(1.5, 0.0), // not the closest point, best time
            Position(10.0, 0.0),
            Position(10.0, 0.0),
            Position(0.0, 0.0), // closest point, worst time
        )

        // both lists have all points in common,
        // but the middle points are the closest at the same time !
        val closestIndex = comparePoints(points, otherPoints)
        val index = 1.0
        assertEquals(index / points.size, closestIndex)
    }
}