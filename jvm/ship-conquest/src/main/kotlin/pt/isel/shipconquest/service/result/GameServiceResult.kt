package pt.isel.shipconquest.service.result

import pt.isel.shipconquest.Either
import pt.isel.shipconquest.domain.minimap.Minimap
import pt.isel.shipconquest.domain.ship.Fleet
import pt.isel.shipconquest.domain.ship.Ship
import pt.isel.shipconquest.domain.user.statistics.PlayerStatistics
import pt.isel.shipconquest.domain.world.Horizon
import pt.isel.shipconquest.domain.world.islands.IslandList
import pt.isel.shipconquest.domain.world.islands.OwnedIsland

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
    object GameNotFound: NavigationError()
    object InvalidNavigationPath: NavigationError()
    object ShipNotFound: NavigationError()
}

typealias NavigationResult = Either<NavigationError, Ship>

sealed class GetKnownIslandsError {
    object GameNotFound: GetKnownIslandsError()
}

typealias GetKnownIslandsResult = Either<GetKnownIslandsError, IslandList>

sealed class ConquestIslandError {
    object GameNotFound: ConquestIslandError()
    object NotEnoughCurrency: ConquestIslandError()
    object ShipNotFound: ConquestIslandError()
    object IslandNotFound: ConquestIslandError()
    object AlreadyOwnedIsland: ConquestIslandError()
    object ShipTooFarAway: ConquestIslandError()
    object PlayerStatisticsNotFound: ConquestIslandError()
}

typealias ConquestIslandResult = Either<ConquestIslandError, OwnedIsland>

sealed class GetShipError {
    object GameNotFound: GetShipError()
    object ShipNotFound: GetShipError()
}

typealias GetShipResult = Either<GetShipError, Ship>

sealed class GetShipsError {
    object GameNotFound: GetShipsError()
}

typealias GetShipsResult = Either<GetShipsError, Fleet>

sealed class CreateShipError {
    object NotEnoughCurrency: CreateShipError()

    object PlayerStatisticsNotFound: CreateShipError()

    object GameNotFound: CreateShipError()
}

typealias CreateShipResult = Either<CreateShipError, Ship>