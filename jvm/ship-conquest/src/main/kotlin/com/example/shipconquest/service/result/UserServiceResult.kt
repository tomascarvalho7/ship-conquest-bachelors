package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.domain.user.Token

sealed class ProcessUserError {
    object InvalidIDToken: ProcessUserError()
    object TokenCreationFailed: ProcessUserError()
}

typealias ProcessUserResult = Either<ProcessUserError, Token>