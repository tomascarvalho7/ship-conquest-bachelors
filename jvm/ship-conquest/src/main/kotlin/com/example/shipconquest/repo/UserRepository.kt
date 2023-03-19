package com.example.shipconquest.repo

import com.example.shipconquest.domain.user.Token
import org.slf4j.Logger

interface UserRepository {
    val logger: Logger

    fun checkUserExists(googleId: String): Boolean
    fun createUser(googleId: String, name: String, email:String)
    fun updateUserToken(googleId: String, token: Token)
    fun doesTokenExist(token: Token): Boolean
}