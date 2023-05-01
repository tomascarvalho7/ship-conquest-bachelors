package com.example.shipconquest.repo

import com.example.shipconquest.domain.user.Token
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.domain.user.UserInfo
import org.slf4j.Logger

interface UserRepository {
    val logger: Logger

    fun checkUserExists(googleId: String): Boolean
    fun createUser(googleId: String, name: String, email:String, imageUrl: String)
    fun updateUserToken(googleId: String, token: Token)
    fun doesTokenExist(token: Token): Boolean
    fun authenticateUserByToken(token: String): User?
    fun getUserInfo(userId: String): UserInfo?
}