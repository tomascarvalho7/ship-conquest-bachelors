package com.example.shipconquest.controller

import com.example.shipconquest.Either
import com.example.shipconquest.controller.model.Problem
import com.example.shipconquest.controller.model.input.LobbyInputModel
import com.example.shipconquest.controller.model.output.*
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.service.LobbyService
import com.example.shipconquest.service.result.CreateLobbyError
import com.example.shipconquest.service.result.GetAllLobbiesError
import com.example.shipconquest.service.result.GetLobbyError
import com.example.shipconquest.service.result.JoinLobbyError
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
class LobbyController(val service: LobbyService) {
    @PostMapping("/create-lobby")
    fun createLobby(user: User, @RequestBody lobby: LobbyInputModel): ResponseEntity<*> {
        val result = service.createLobby(name = lobby.name, user.id)
        return when (result) {
            is Either.Right -> response(content = CreateLobbyOutputModel(tag = result.value))
            is Either.Left -> when (result.value) {
                CreateLobbyError.InvalidServerName ->
                    Problem.response(status = 400, problem = Problem.invalidLobbyName())
            }
        }
    }

    @GetMapping("/get-lobby")
    fun getLobby(user: User, @RequestParam tag: String): ResponseEntity<*> {
        val result = service.getLobby(tag)
        return when (result) {
            is Either.Right -> response(content = result.value.toLobbyOutputModel())
            is Either.Left -> when (result.value) {
                GetLobbyError.LobbyNotFound ->
                    Problem.response(status = 404, problem = Problem.lobbyNotFound())
            }
        }
    }

    @PostMapping("/{tag}/join")
    fun joinLobby(user: User, @PathVariable tag: String): ResponseEntity<*> {
        val result = service.joinLobby(user.id, tag)

        return when (result) {
            is Either.Right -> response(content = JoinLobbyOutputModel(tag))
            is Either.Left -> when (result.value) {
                JoinLobbyError.LobbyNotFound ->
                    Problem.response(status = 404, problem = Problem.lobbyNotFound())
            }
        }
    }

    @GetMapping("/lobbies")
    fun getLobbies(
        user: User,
        @RequestParam(required = false) skip: Int?,
        @RequestParam(required = false) limit: Int?,
        @RequestParam(required = false) order: String?,
        @RequestParam(required = false) name: String?,
    ): ResponseEntity<*> {
        val result = service.getLobbies(skip, limit, order, name)

        return when (result) {
            is Either.Right -> response(content = LobbyListOutputModel(lobbies = result.value.map { lobby ->
                LobbyOutputModel(
                    lobby.tag,
                    lobby.name,
                    lobby.uid,
                    lobby.username,
                    lobby.creationTime
                )
            }))

            is Either.Left -> when (result.value) {
                GetAllLobbiesError.InvalidOrderParameter ->
                    Problem.response(status = 400, problem = Problem.invalidOrderParameter())

            }
        }
    }

    private fun <T> response(content: T) = ResponseEntity
        .status(200)
        .header("Content-Type", "application/json")
        .body(content)
}