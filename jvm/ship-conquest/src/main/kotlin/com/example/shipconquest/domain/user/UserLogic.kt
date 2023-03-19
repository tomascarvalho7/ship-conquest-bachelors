package com.example.shipconquest.domain.user

import org.springframework.stereotype.Component
import java.security.SecureRandom
import java.util.*

@Component
class UserLogic {
    fun generateToken(): String = ByteArray(TOKEN_BYTE_SIZE)
        .let { byteArray ->
            SecureRandom.getInstanceStrong().nextBytes(byteArray)
            Base64.getUrlEncoder().encodeToString(byteArray)
        }

    fun canBeToken(token: Token): Boolean = try {
        Base64.getUrlDecoder()
            .decode(token.value).size == TOKEN_BYTE_SIZE
    } catch (ex: IllegalArgumentException) {
        false
    }

    companion object {
        private const val TOKEN_BYTE_SIZE = 256 / 8
    }
}