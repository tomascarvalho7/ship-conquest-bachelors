package pt.isel.shipconquest.service.result

import pt.isel.shipconquest.Either
import com.example.shipconquest.domain.user.Token
import com.example.shipconquest.domain.user.UserInfo

sealed class CreateUserError {
    object InvalidIDToken: CreateUserError()
    object TokenCreationFailed: CreateUserError()
    object UserAlreadyExists: CreateUserError()
}

typealias CreateUserResult = pt.isel.shipconquest.Either<CreateUserError, Token>

sealed class LoginUserError {
    object InvalidIDToken: LoginUserError()
    object TokenCreationFailed: LoginUserError()
    object UserNotFound: LoginUserError()
}

typealias LoginUserResult = pt.isel.shipconquest.Either<LoginUserError, Token>


sealed class GetUserInfoError {
    object UserNotFound: GetUserInfoError()
}

typealias GetUserInfoResult = pt.isel.shipconquest.Either<GetUserInfoError, UserInfo>