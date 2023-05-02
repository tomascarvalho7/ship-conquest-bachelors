package com.example.shipconquest.controller

import com.example.shipconquest.Either
import com.example.shipconquest.controller.model.Problem
import com.example.shipconquest.controller.model.output.TokenOutputModel
import com.example.shipconquest.controller.model.output.UserInfoOutputModel
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.service.UserService
import com.example.shipconquest.service.result.GetUserInfoError
import com.example.shipconquest.service.result.ProcessUserError
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RestController
import java.util.*
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier
import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.client.json.gson.GsonFactory
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestBody

@RestController
class UserController(val service: UserService) {
    @PostMapping("get-token")
    fun getToken(@RequestBody idtoken: String): ResponseEntity<*> {
        val decodedJWT = decodeJWT(idtoken.substringAfter('='))
        return if (decodedJWT != null) {
            val result = service.processUser(
                decodedJWT.subject,
                decodedJWT["name"]?.toString() ?: "",
                decodedJWT.email,
                decodedJWT["picture"]?.toString() ?: ""
                )

            when (result) {
                is Either.Right -> response(content = TokenOutputModel(token = result.value.value))
                is Either.Left -> when (result.value) {
                    ProcessUserError.InvalidIDToken ->
                        Problem.response(status = 401, problem = Problem.invalidIdToken())
                    ProcessUserError.TokenCreationFailed -> Problem.response(status = 400, problem = Problem.tokenCreationFailed())
                }
            }
        } else {
            Problem.response(status = 401, problem = Problem.invalidIdToken())
        }
    }

    @GetMapping("/userinfo")
    fun getUserInfo(user: User): ResponseEntity<*> {
        val result =  service.getUserInfo(user.id)

        return when (result) {
            is Either.Right -> response(content = UserInfoOutputModel(
                name = result.value.name,
                email = result.value.email,
                imageUrl = result.value.imageUrl)
            )
            is Either.Left -> when(result.value) {
                GetUserInfoError.UserNotFound ->
                    Problem.response(status = 404, problem = Problem.userNotFound())
            }
        }
    }



    //ta repetido em varios controllers, melhorar
    private fun <T> response(content: T) = ResponseEntity
        .status(200)
        .header("Content-Type", "application/json")
        .body(content)
}

fun decodeJWT(jwt: String): Payload? {
    val verifier =
        GoogleIdTokenVerifier.Builder(NetHttpTransport(), GsonFactory())
            .setAudience(listOf("48002922994-37rvess4o1fgim6mta4tmvefrmf1gu8b.apps.googleusercontent.com"))
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
