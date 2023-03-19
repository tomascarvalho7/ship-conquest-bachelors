package com.example.shipconquest.service

import com.example.shipconquest.domain.user.Token
import com.example.shipconquest.domain.user.UserLogic
import com.example.shipconquest.domain.user.toToken
import com.example.shipconquest.left
import com.example.shipconquest.repo.Transaction
import com.example.shipconquest.repo.TransactionManager
import com.example.shipconquest.right
import com.example.shipconquest.service.result.ProcessUserError
import com.example.shipconquest.service.result.ProcessUserResult
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service

@Service
class UserService(
    override val transactionManager: TransactionManager,
    private val userLogic: UserLogic,
): ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun processUser(googleId: String, name: String, email: String): ProcessUserResult {
        //add verification logic, maybe check name size?

        return transactionManager.run { transaction ->

            if(!transaction.userRepo.checkUserExists(googleId)) {
                //user doesn't exist, create one
                transaction.userRepo.createUser(googleId, name, email)
            }
            val userToken = generateValidToken(googleId, transaction)

            if(userToken != null) {
                return@run right(userToken)
            } else {
                return@run left(ProcessUserError.TokenCreationFailed)
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