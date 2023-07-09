package pt.isel.shipconquest.service.result

import pt.isel.shipconquest.Either
import com.example.shipconquest.domain.minimap.Minimap
import com.example.shipconquest.domain.ship.Fleet
import com.example.shipconquest.domain.ship.Ship
import com.example.shipconquest.domain.user.statistics.PlayerStatistics
import com.example.shipconquest.domain.world.Horizon
import com.example.shipconquest.domain.world.islands.IslandList
import com.example.shipconquest.domain.world.islands.OwnedIsland

sealed class GetChunksError {
    object GameNotFound: GetChunksError()
    object ShipPositionNotFound: GetChunksError()
}

typealias GetChunksResult = pt.isel.shipconquest.Either<GetChunksError, Horizon>

sealed class GetPlayerStatsError {
    object StatisticsNotFound: GetPlayerStatsError()
    object GameNotFound: GetPlayerStatsError()
}

typealias GetPlayerStatsResult = pt.isel.shipconquest.Either<GetPlayerStatsError, PlayerStatistics>

sealed class GetMinimapError {
    object GameNotFound: GetMinimapError()
    object NoTrackedRecord: GetMinimapError()
}

typealias GetMinimapResult = pt.isel.shipconquest.Either<GetMinimapError, Minimap>

sealed class NavigationError {
    object GameNotFound: NavigationError()
    object InvalidNavigationPath: NavigationError()
    object ShipNotFound: NavigationError()
}

typealias NavigationResult = pt.isel.shipconquest.Either<NavigationError, Ship>

sealed class GetKnownIslandsError {
    object GameNotFound: GetKnownIslandsError()
}

typealias GetKnownIslandsResult = pt.isel.shipconquest.Either<GetKnownIslandsError, IslandList>

sealed class GetUnknownIslandsError {
    object GameNotFound: GetUnknownIslandsError()
}

typealias GetUnknownIslandsResult = pt.isel.shipconquest.Either<GetUnknownIslandsError, List<Int>> // TODO change this return type


sealed class ConquestIslandError {
    object GameNotFound: ConquestIslandError()
    object NotEnoughCurrency: ConquestIslandError()
    object ShipNotFound: ConquestIslandError()
    object IslandNotFound: ConquestIslandError()
    object AlreadyOwnedIsland: ConquestIslandError()
    object ShipTooFarAway: ConquestIslandError()
    object PlayerStatisticsNotFound: ConquestIslandError()
}

typealias ConquestIslandResult = pt.isel.shipconquest.Either<ConquestIslandError, OwnedIsland>

sealed class GetShipError {
    object GameNotFound: GetShipError()
    object ShipNotFound: GetShipError()
}

typealias GetShipResult = pt.isel.shipconquest.Either<GetShipError, Ship>

sealed class GetShipsError {
    object GameNotFound: GetShipsError()
}

typealias GetShipsResult = pt.isel.shipconquest.Either<GetShipsError, Fleet>

sealed class CreateShipError {
    object NotEnoughCurrency: CreateShipError()

    object PlayerStatisticsNotFound: CreateShipError()

    object GameNotFound: CreateShipError()
}

typealias CreateShipResult = pt.isel.shipconquest.Either<CreateShipError, Ship>