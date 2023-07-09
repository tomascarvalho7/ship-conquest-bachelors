package pt.isel.shipconquest.repo

import org.slf4j.Logger
import pt.isel.shipconquest.domain.user.Token
import pt.isel.shipconquest.domain.user.User
import pt.isel.shipconquest.domain.user.UserInfo

interface UserRepository {
    val logger: Logger

    fun checkUserExists(googleId: String): Boolean
    fun createUser(username: String, googleId: String, name: String, email:String, imageUrl: String?, description: String?)
    fun updateUserToken(googleId: String, token: Token)
    fun doesTokenExist(token: Token): Boolean
    fun authenticateUserByToken(token: String): User?
    fun getUserInfo(userId: String): UserInfo?
}