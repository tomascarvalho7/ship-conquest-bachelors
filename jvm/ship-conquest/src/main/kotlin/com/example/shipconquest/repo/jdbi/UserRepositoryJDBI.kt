package com.example.shipconquest.repo.jdbi

import com.example.shipconquest.domain.user.Token
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.repo.UserRepository
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.slf4j.Logger
import org.slf4j.LoggerFactory

class UserRepositoryJDBI(private val handle: Handle): UserRepository {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    override fun checkUserExists(googleId: String): Boolean {
        logger.info("Checking if user with id = {} exists", googleId)
        val userCount = handle.createQuery("SELECT count(*) from dbo.user where id = :googleId")
            .bind("googleId", googleId)
            .mapTo<Int>()
            .single()

        return userCount != 0
    }

    override fun createUser(googleId: String, name: String, email: String) {
        logger.info("Creating a user from googleId = {}", googleId)
        handle.createUpdate("INSERT into dbo.user values (:gid, :name, :email);")
            .bind("gid", googleId)
            .bind("name", name)
            .bind("email", email)
            .execute()
    }

    override fun updateUserToken(googleId: String, token: Token) {
        logger.info("Creating a new token for user with id = {}", googleId)
        handle.createUpdate("INSERT into dbo.token values(:token, :gid);")
            .bind("gid", googleId)
            .bind("token", token.value)
            .execute()
    }

    override fun doesTokenExist(token: Token): Boolean {
        logger.info("Checking if token exists")
        val tokenCount = handle.createQuery("SELECT count(*) from dbo.token where token = :token;")
            .bind("token", token.value)
            .mapTo<Int>()
            .single()

        return tokenCount != 0
    }

    override fun authenticateUserByToken(token: String): User {
        logger.info("Checking if user token exists and getting user")
        return handle.createQuery(
            "select u.id, u.name from dbo.user u join dbo.token t on t.uid = u.id where t.token = :token;"
        ).bind("token", token)
            .mapTo<User>()
            .single()
    }
}