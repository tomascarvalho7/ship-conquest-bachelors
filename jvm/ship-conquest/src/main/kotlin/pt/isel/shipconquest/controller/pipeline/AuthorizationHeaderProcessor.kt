package pt.isel.shipconquest.controller.pipeline

import com.example.shipconquest.domain.user.User
import com.example.shipconquest.service.UserService
import org.springframework.stereotype.Component

@Component
class AuthorizationHeaderProcessor(
    val usersService: UserService
) {
    fun process(authorizationValue: String?): User? {
        if (authorizationValue == null) {
            return null
        }
        val splitAuth = authorizationValue.trim().split(" ")
        if (splitAuth.size != 2 || splitAuth[0].lowercase() != SCHEME) {
            return null
        }
        return usersService.authenticate(splitAuth[1])
    }

    companion object {
        const val SCHEME = "bearer"
    }
}
