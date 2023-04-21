package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.controller.model.output.ShipPathOutputModel
import com.example.shipconquest.domain.Coord2D
import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.ShipPathTime
import com.example.shipconquest.domain.Vector3
import com.example.shipconquest.domain.ship_navigation.ShipPath
import java.time.Duration
import java.time.LocalDateTime

sealed class GetChunksError {
    object GameNotFound: GetChunksError()
    object ShipPositionNotFound: GetChunksError()
}

typealias GetChunksResult = Either<GetChunksError, List<Vector3>>

sealed class GetMinimapError {
    object GameNotFound: GetMinimapError()
    object NoTrackedRecord: GetMinimapError()
}

typealias GetMinimapResult = Either<GetMinimapError, List<Vector3>>

sealed class NavigationError {
    object InvalidNavigationPath: NavigationError()
}

typealias NavigationResult = Either<NavigationError, ShipPathTime>

sealed class GetShipPositionError {
    object ShipNotFound: GetShipPositionError()
}

typealias GetShipPositionResult = Either<GetShipPositionError, Coord2D>

sealed class GetShipPathError {
    object ShipNotFound: GetShipPathError()
}

typealias GetShipPathResult = Either<GetShipPathError, ShipPathOutputModel>