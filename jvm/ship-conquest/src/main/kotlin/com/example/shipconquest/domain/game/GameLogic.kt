package com.example.shipconquest.domain.game

import com.example.shipconquest.Clock
import com.example.shipconquest.domain.Vector2
import com.example.shipconquest.domain.path_finding.calculateEuclideanDistance
import com.example.shipconquest.domain.user.statistics.PlayerStatsBuilder
import com.example.shipconquest.domain.user.statistics.build
import com.example.shipconquest.domain.world.islands.Island
import com.example.shipconquest.domain.world.islands.OwnedIsland
import com.example.shipconquest.domain.world.islands.WildIsland
import com.example.shipconquest.service.formatDuration
import org.springframework.stereotype.Component
import java.time.Duration
import java.time.Instant
import kotlin.math.roundToLong

const val incomePerHour = 25
@Component
class GameLogic(private val clock: Clock) {
    fun conquestIsland(
        uid: String,
        island: Island,
        onWild: (old: WildIsland, new: OwnedIsland) -> Unit,
        onOwned: (old: OwnedIsland, new: OwnedIsland) -> Unit
    ): OwnedIsland {
        val newIsland = OwnedIsland(
            islandId = island.islandId,
            coordinate = island.coordinate,
            radius = island.radius,
            incomePerHour = incomePerHour,
            conquestDate = clock.now(),
            uid = uid
        )

        when(island) {
            is WildIsland -> onWild(island, newIsland)
            is OwnedIsland -> onOwned(island, newIsland)
        }
        return newIsland
    }

    fun buildPlayerStatistics(builder: PlayerStatsBuilder) = builder.build(clock.now())

    fun buildShipPath(points: List<Vector2>): Pair<Instant, Duration> {
        var distance = 0.0;
        for (i in 0 until points.size - 1) {
            val a = points[i];
            val b = points[i + 1];
            distance += calculateEuclideanDistance(a, b)
        }
        val duration = Duration.ofSeconds((distance * 10).roundToLong())

        return Pair(clock.now(), duration)
    }
}