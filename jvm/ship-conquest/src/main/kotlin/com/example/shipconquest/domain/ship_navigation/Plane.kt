package com.example.shipconquest.domain.ship_navigation

import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.ship_navigation.utils.isInsidePlane

data class Plane(val a: Position, val b: Position, val c: Position, val d: Position)

fun Plane.isOverlapping(other: Plane) =
    a.isInsidePlane(other) || b.isInsidePlane(other) || c.isInsidePlane(other) || d.isInsidePlane(other)

fun Plane.getIntersection(other: Plane): Position? = TODO("implement")