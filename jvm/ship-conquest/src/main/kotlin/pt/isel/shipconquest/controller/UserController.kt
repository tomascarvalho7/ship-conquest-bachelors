package pt.isel.shipconquest.controller

import pt.isel.shipconquest.Either
import com.example.shipconquest.controller.model.Problem
import com.example.shipconquest.controller.model.input.CreateUserInputModel
import com.example.shipconquest.controller.model.output.TokenOutputModel
import com.example.shipconquest.controller.model.output.TokenPingOutputModel
import com.example.shipconquest.controller.model.output.UserInfoOutputModel
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.service.UserService
import com.example.shipconquest.service.result.CreateUserError
import com.example.shipconquest.service.result.GetUserInfoError
import com.example.shipconquest.service.result.LoginUserError
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController
import java.util.*
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier
import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.client.json.gson.GsonFactory
import org.springframework.beans.factory.annotation.Value
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam

@RestController
class UserController(val service: UserService) {
    @PostMapping("create-user")
    fun createUser(@RequestBody body: CreateUserInputModel): ResponseEntity<*> {
        val decodedJWT = decodeJWT(body.idtoken)
        return if (decodedJWT != null) {
            val result = service.createUser(
                body.username,
                decodedJWT.subject,
                decodedJWT["name"]?.toString() ?: "",
                decodedJWT.email,
                decodedJWT["picture"]?.toString(),
                body.description
                )

            when (result) {
                is pt.isel.shipconquest.Either.Right -> response(content = TokenOutputModel(token = result.value.value))
                is pt.isel.shipconquest.Either.Left -> when (result.value) {
                    CreateUserError.InvalidIDToken ->
                        Problem.response(status = 401, problem = Problem.invalidIdToken())
                    CreateUserError.TokenCreationFailed -> Problem.response(status = 400, problem = Problem.tokenCreationFailed())
                    CreateUserError.UserAlreadyExists -> Problem.response(status = 400, problem = Problem.userAlreadyExists())
                }
            }
        } else {
            Problem.response(status = 401, problem = Problem.invalidIdToken())
        }
    }

    @PostMapping("get-token")
    fun loginUser(@RequestBody idtoken: String): ResponseEntity<*> {
        val decodedJWT = decodeJWT(idtoken.substringAfter('='))
        return if (decodedJWT != null) {
            val result = service.loginUser(
                decodedJWT.subject,
                decodedJWT["name"]?.toString() ?: "",
                decodedJWT.email,
            )

            when (result) {
                is pt.isel.shipconquest.Either.Right -> response(content = TokenOutputModel(token = result.value.value))
                is pt.isel.shipconquest.Either.Left -> when (result.value) {
                    LoginUserError.InvalidIDToken ->
                        Problem.response(status = 401, problem = Problem.invalidIdToken())
                    LoginUserError.TokenCreationFailed -> Problem.response(status = 400, problem = Problem.tokenCreationFailed())
                    LoginUserError.UserNotFound -> Problem.response(status = 404, problem = Problem.userNotFound())
                }
            }
        } else {
            Problem.response(status = 401, problem = Problem.invalidIdToken())
        }
    }

    @PostMapping("check-token")
    fun checkTokenIsValid(user: User): ResponseEntity<*> {
        // no need to do any operations, if the request
        // passes the interceptor, the token is valid
        return response(content = TokenPingOutputModel(result = "Token is valid."))
    }

    @GetMapping("/userinfo")
    fun getUserInfo(user: User): ResponseEntity<*> {
        val result =  service.getUserInfo(user.id)

        return when (result) {
            is pt.isel.shipconquest.Either.Right -> response(content = UserInfoOutputModel(
                username = result.value.username,
                name = result.value.name,
                email = result.value.email,
                imageUrl = result.value.imageUrl,
                description = result.value.description)
            )
            is pt.isel.shipconquest.Either.Left -> when(result.value) {
                GetUserInfoError.UserNotFound ->
                    Problem.response(status = 404, problem = Problem.userNotFound())
            }
        }
    }

    private fun <T> response(content: T) = ResponseEntity
        .status(200)
        .header("Content-Type", "application/json")
        .body(content)
}

fun decodeJWT(jwt: String): Payload? {
    val clientId = System.getenv("SCONQUEST_CLIENT_ID")
    val verifier =
        GoogleIdTokenVerifier.Builder(NetHttpTransport(), GsonFactory())
            .setAudience(listOf(clientId))
            .build()
    val idToken = verifier.verify(jwt)
    return if (idToken != null) {
        println("id token payload" + idToken.payload)
        idToken.payload
    } else {
        println("Invalid ID token.")
        null
    }
}
