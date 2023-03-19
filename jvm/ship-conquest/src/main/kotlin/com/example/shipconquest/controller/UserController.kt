package com.example.shipconquest.controller

import com.example.shipconquest.Either
import com.example.shipconquest.controller.model.Problem
import com.example.shipconquest.controller.model.output.HorizonOutputModel
import com.example.shipconquest.service.UserService
import com.example.shipconquest.service.result.GetChunksError
import com.example.shipconquest.service.result.ProcessUserError
import com.example.shipconquest.service.result.ProcessUserResult
import org.springframework.http.HttpHeaders
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestHeader
import org.springframework.web.bind.annotation.RestController
import java.util.*
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken
import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken.Payload
import com.google.api.client.googleapis.auth.oauth2.GoogleIdTokenVerifier
import com.google.api.client.http.javanet.NetHttpTransport
import com.google.api.client.json.gson.GsonFactory
import org.springframework.http.ResponseEntity

@RestController
class UserController(val service: UserService) {
    @PostMapping("get-token")
    fun getToken(@RequestHeader(HttpHeaders.AUTHORIZATION) auth: String): ResponseEntity<*> {
        val decodedJWT = decodeJWT(auth.substringAfter(' '))
        return if (decodedJWT != null) {
            val result = service.processUser(decodedJWT.subject, decodedJWT["name"]?.toString() ?: "", decodedJWT.email)

            when (result) {
                is Either.Right -> response(content = result.value)
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

    //ta repetido em varios controllers, melhorar
    private fun <T> response(content: T) = ResponseEntity
        .status(200)
        .header("Content-Type", "application/json")
        .body(content)
}

fun decodeJWT(jwt: String): Payload? {
    val verifier =
        GoogleIdTokenVerifier.Builder(NetHttpTransport(), GsonFactory())
            .setAudience(listOf("ship-conquest"))
            .build()

    val idToken = verifier.verify(jwt)
    return if (idToken != null) {
        idToken.payload
    } else {
        println("Invalid ID token.")
        null
    }
}
