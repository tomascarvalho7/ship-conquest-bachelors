package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.domain.user.Token
import com.example.shipconquest.domain.user.UserInfo

sealed class CreateUserError {
    object InvalidIDToken: CreateUserError()
    object TokenCreationFailed: CreateUserError()
    object UserAlreadyExists: CreateUserError()
}

typealias CreateUserResult = Either<CreateUserError, Token>

sealed class LoginUserError {
    object InvalidIDToken: LoginUserError()
    object TokenCreationFailed: LoginUserError()
    object UserNotFound: LoginUserError()
}

typealias LoginUserResult = Either<LoginUserError, Token>


sealed class GetUserInfoError {
    object UserNotFound: GetUserInfoError()
}

typealias GetUserInfoResult = Either<GetUserInfoError, UserInfo>