package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.domain.Vector3

sealed class GetChunksError {
    object GameNotFound: GetChunksError()
}

typealias GetChunksResult = Either<GetChunksError, List<Vector3>>