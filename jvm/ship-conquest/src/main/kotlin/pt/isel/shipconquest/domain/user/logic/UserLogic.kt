package pt.isel.shipconquest.domain.user.logic

import com.example.shipconquest.domain.user.Token
import org.springframework.stereotype.Component
import java.security.SecureRandom
import java.util.*

/**
 * The [UserLogic] class handles all the user-related logic, including:
 * - Generating a random secure token.
 */
@Component
class UserLogic {
    fun generateToken(): String = ByteArray(TOKEN_BYTE_SIZE)
        .let { byteArray ->
            SecureRandom.getInstanceStrong().nextBytes(byteArray)
            Base64.getUrlEncoder().encodeToString(byteArray)
        }
    companion object {
        private const val TOKEN_BYTE_SIZE = 256 / 8
    }
}