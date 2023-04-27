package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.controller.model.output.ShipLocationOutputModel
import com.example.shipconquest.domain.ShipPathTime
import com.example.shipconquest.domain.Vector3
import com.example.shipconquest.domain.user.statistics.PlayerStats
import com.example.shipconquest.domain.world.Horizon
import com.example.shipconquest.domain.world.islands.OwnedIsland

sealed class GetChunksError {
    object GameNotFound: GetChunksError()
    object ShipPositionNotFound: GetChunksError()
}

typealias GetChunksResult = Either<GetChunksError, Horizon>

sealed class GetPlayerStatsError {
    object StatisticsNotFound: GetPlayerStatsError()
    object GameNotFound: GetPlayerStatsError()
}

typealias GetPlayerStatsResult = Either<GetPlayerStatsError, PlayerStats>

sealed class GetMinimapError {
    object GameNotFound: GetMinimapError()
    object NoTrackedRecord: GetMinimapError()
}

typealias GetMinimapResult = Either<GetMinimapError, List<Vector3>>

sealed class NavigationError {
    object InvalidNavigationPath: NavigationError()
}

typealias NavigationResult = Either<NavigationError, ShipPathTime>

sealed class ConquestIslandError {
    object GameNotFound: ConquestIslandError()
    object NotEnoughCurrency: ConquestIslandError()
    object ShipNotFound: ConquestIslandError()
    object IslandNotFound: ConquestIslandError()
    object ShipTooFarAway: ConquestIslandError()
}

typealias ConquestIslandResult = Either<ConquestIslandError, OwnedIsland>

sealed class GetShipLocationError {
    object ShipNotFound: GetShipLocationError()
}

typealias GetShipLocationResult = Either<GetShipLocationError, ShipLocationOutputModel>
