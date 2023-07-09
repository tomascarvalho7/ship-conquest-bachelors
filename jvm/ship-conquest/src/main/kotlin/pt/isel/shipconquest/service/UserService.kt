package pt.isel.shipconquest.service

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import pt.isel.shipconquest.domain.user.Token
import pt.isel.shipconquest.domain.user.User
import pt.isel.shipconquest.domain.user.logic.UserLogic
import pt.isel.shipconquest.domain.user.toToken
import pt.isel.shipconquest.repo.Transaction
import pt.isel.shipconquest.repo.TransactionManager
import pt.isel.shipconquest.service.result.*

@Service
class UserService(
    override val transactionManager: TransactionManager,
    private val userLogic: UserLogic,
): ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun authenticate(token: String): User? {
        return transactionManager.run {transaction ->
            transaction.userRepo.authenticateUserByToken(token)
        }
    }

    fun createUser(username: String, googleId: String, name: String, email: String, imageUrl: String?, description: String?): CreateUserResult {
        return transactionManager.run { transaction ->

            if(!transaction.userRepo.checkUserExists(googleId)) {
                transaction.userRepo.createUser(username, googleId, name, email, imageUrl, description)
            } else {
                return@run pt.isel.shipconquest.left(CreateUserError.UserAlreadyExists)
            }
            val userToken = generateValidToken(googleId, transaction)

            if(userToken != null) {
                return@run pt.isel.shipconquest.right(userToken)
            } else {
                return@run pt.isel.shipconquest.left(CreateUserError.TokenCreationFailed)
            }
        }
    }

    fun loginUser(googleId: String, name: String, email: String): LoginUserResult {
        return transactionManager.run { transaction ->

            if(!transaction.userRepo.checkUserExists(googleId)) {
                return@run pt.isel.shipconquest.left(LoginUserError.UserNotFound)
            }
            val userToken = generateValidToken(googleId, transaction)

            if(userToken != null) {
                return@run pt.isel.shipconquest.right(userToken)
            } else {
                return@run pt.isel.shipconquest.left(LoginUserError.TokenCreationFailed)
            }
        }
    }

    fun getUserInfo(userId: String): GetUserInfoResult {
        return transactionManager.run { transaction ->
            val userInfo = transaction.userRepo.getUserInfo(userId) ?: return@run pt.isel.shipconquest.left(
                GetUserInfoError.UserNotFound
            )
            pt.isel.shipconquest.right(userInfo)
        }
    }

    fun generateValidToken(googleId: String, transaction: Transaction): Token? {
        val maxTries = 3
        var tries = 0
        var newToken: Token
        while (true) {
            newToken = userLogic.generateToken().toToken()
            if (!transaction.userRepo.doesTokenExist(newToken)) break
            if(tries == maxTries) return null
            tries++
        }
        transaction.userRepo.updateUserToken(googleId, newToken)
        return newToken
    }
}