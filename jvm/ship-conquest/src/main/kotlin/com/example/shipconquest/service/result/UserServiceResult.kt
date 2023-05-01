package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.domain.user.Token
import com.example.shipconquest.domain.user.UserInfo

sealed class ProcessUserError {
    object InvalidIDToken: ProcessUserError()
    object TokenCreationFailed: ProcessUserError()
}

typealias ProcessUserResult = Either<ProcessUserError, Token>

sealed class GetUserInfoError {
    object UserNotFound: GetUserInfoError()
}

typealias GetUserInfoResult = Either<GetUserInfoError, UserInfo>