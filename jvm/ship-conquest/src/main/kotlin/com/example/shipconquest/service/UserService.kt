package com.example.shipconquest.service

import com.example.shipconquest.domain.user.Token
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.domain.user.UserLogic
import com.example.shipconquest.domain.user.toToken
import com.example.shipconquest.left
import com.example.shipconquest.repo.Transaction
import com.example.shipconquest.repo.TransactionManager
import com.example.shipconquest.right
import com.example.shipconquest.service.result.*
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service

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
                return@run left(CreateUserError.UserAlreadyExists)
            }
            val userToken = generateValidToken(googleId, transaction)

            if(userToken != null) {
                return@run right(userToken)
            } else {
                return@run left(CreateUserError.TokenCreationFailed)
            }
        }
    }

    fun loginUser(googleId: String, name: String, email: String): LoginUserResult {
        return transactionManager.run { transaction ->

            if(!transaction.userRepo.checkUserExists(googleId)) {
                return@run left(LoginUserError.UserNotFound)
            }
            val userToken = generateValidToken(googleId, transaction)

            if(userToken != null) {
                return@run right(userToken)
            } else {
                return@run left(LoginUserError.TokenCreationFailed)
            }
        }
    }

    fun getUserInfo(userId: String): GetUserInfoResult {
        return transactionManager.run { transaction ->
            val userInfo = transaction.userRepo.getUserInfo(userId)
            if (userInfo != null) {
                right(userInfo)
            } else {
                left(GetUserInfoError.UserNotFound)
            }
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