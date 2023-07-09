package pt.isel.shipconquest.service.result

import pt.isel.shipconquest.Either
import pt.isel.shipconquest.domain.user.Token
import pt.isel.shipconquest.domain.user.UserInfo

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