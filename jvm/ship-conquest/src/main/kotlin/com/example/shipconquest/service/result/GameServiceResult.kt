package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.domain.Minimap
import com.example.shipconquest.domain.ShipPathTime
import com.example.shipconquest.domain.ship_navigation.ship.Fleet
import com.example.shipconquest.domain.ship_navigation.ship.Ship
import com.example.shipconquest.domain.user.statistics.PlayerStatistics
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

typealias GetPlayerStatsResult = Either<GetPlayerStatsError, PlayerStatistics>

sealed class GetMinimapError {
    object GameNotFound: GetMinimapError()
    object NoTrackedRecord: GetMinimapError()
}

typealias GetMinimapResult = Either<GetMinimapError, Minimap>

sealed class NavigationError {
    object InvalidNavigationPath: NavigationError()
}

typealias NavigationResult = Either<NavigationError, Ship>

sealed class ConquestIslandError {
    object GameNotFound: ConquestIslandError()
    object NotEnoughCurrency: ConquestIslandError()
    object ShipNotFound: ConquestIslandError()
    object IslandNotFound: ConquestIslandError()
    object ShipTooFarAway: ConquestIslandError()
    object PlayerStatisticsNotFound: ConquestIslandError()
}

typealias ConquestIslandResult = Either<ConquestIslandError, OwnedIsland>

sealed class GetShipError {
    object ShipNotFound: GetShipError()
}

typealias GetShipResult = Either<GetShipError, Ship>

// TODO: give more errors
typealias GetShipsResult = Either<Nothing, Fleet>