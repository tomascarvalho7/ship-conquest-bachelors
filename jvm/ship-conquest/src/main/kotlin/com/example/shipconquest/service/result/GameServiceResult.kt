package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.Vector3

sealed class GetChunksError {
    object GameNotFound: GetChunksError()
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

typealias NavigationResult = Either<NavigationError, String>