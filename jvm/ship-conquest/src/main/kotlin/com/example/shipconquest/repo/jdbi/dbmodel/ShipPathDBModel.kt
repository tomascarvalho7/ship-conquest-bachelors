package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.ship_navigation.ShipPath
import java.time.Duration
import java.time.LocalDateTime

data class ShipPathDBModel(val landmarks: Array<CubicBezierDBModel>, val startTime: LocalDateTime, val duration: Duration) {
    override fun equals(other: Any?): Boolean {
        if (this === other) return true
        if (javaClass != other?.javaClass) return false

        other as ShipPathDBModel

        if (!landmarks.contentEquals(other.landmarks)) return false
        if (startTime != other.startTime) return false
        if (duration != other.duration) return false

        return true
    }

    override fun hashCode(): Int {
        var result = landmarks.contentHashCode()
        result = 31 * result + startTime.hashCode()
        result = 31 * result + duration.hashCode()
        return result
    }
}

fun ShipPathDBModel.toShipPath(): ShipPath =
    ShipPath(landmarks = landmarks.toCubicBezierList(), startTime = startTime, duration = duration)

fun ShipPath.toShipPathBDModel(): ShipPathDBModel =
    ShipPathDBModel(landmarks = landmarks.map {
        CubicBezierDBModel(it.p0, it.p1, it.p2, it.p3)
    }.toTypedArray(), startTime, duration)