package com.example.shipconquest.controller

import com.example.shipconquest.Either
import com.example.shipconquest.controller.model.Problem
import com.example.shipconquest.controller.model.input.LobbyInputModel
import com.example.shipconquest.controller.model.input.LobbyTagInputModel
import com.example.shipconquest.controller.model.output.*
import com.example.shipconquest.controller.model.output.lobby.*
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.service.LobbyService
import com.example.shipconquest.service.result.*
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

    @GetMapping("/lobbies/all")
    fun getAllLobbies(
        user: User,
        @RequestParam(required = false) skip: Int?,
        @RequestParam(required = false) limit: Int?,
        @RequestParam(required = false) order: String?,
        @RequestParam(required = false) name: String?,
    ): ResponseEntity<*> {
        val result = service.getLobbies(user.id, skip, limit, order, name)

        return when (result) {
            is Either.Right -> response(content = result.value.map { lobby ->
                lobby.toLobbyInfoOutputModel()
            }.toLobbyInfoListOutputModel())

            is Either.Left -> when (result.value) {
                GetLobbyListError.InvalidOrderParameter ->
                    Problem.response(status = 400, problem = Problem.invalidOrderParameter())

            }
        }
    }

    @GetMapping("/lobbies/favorite")
    fun getFavoriteLobbies(
        user: User,
        @RequestParam(required = false) skip: Int?,
        @RequestParam(required = false) limit: Int?,
        @RequestParam(required = false) order: String?,
        @RequestParam(required = false) name: String?
    ): ResponseEntity<*> {
        val result = service.getFavoriteLobbies(user.id, skip, limit, order, name)

        return when (result) {
            is Either.Right -> response(content = result.value.map { lobby ->
                lobby.toLobbyInfoOutputModel()
            }.toLobbyInfoListOutputModel())

            is Either.Left -> when (result.value) {
                GetLobbyListError.InvalidOrderParameter ->
                    Problem.response(status = 400, problem = Problem.invalidOrderParameter())

            }
        }
    }

    @GetMapping("/lobbies/recent")
    fun getRecentLobbies(
        user: User,
        @RequestParam(required = false) skip: Int?,
        @RequestParam(required = false) limit: Int?,
        @RequestParam(required = false) order: String?,
        @RequestParam(required = false) name: String?,
    ): ResponseEntity<*> {
        val result = service.getRecentLobbies(user.id, skip, limit, order, name)

        return when (result) {
            is Either.Right -> response(content = result.value.map { lobby ->
                lobby.toLobbyInfoOutputModel()
            }.toLobbyInfoListOutputModel())

            is Either.Left -> when (result.value) {
                GetLobbyListError.InvalidOrderParameter ->
                    Problem.response(status = 400, problem = Problem.invalidOrderParameter())

            }
        }
    }

    @PostMapping("/lobby/favorite")
    fun setLobbyFavorite(user: User, @RequestBody lobby: LobbyTagInputModel): ResponseEntity<*> {
        val result = service.setFavoriteLobby(user.id, lobby.tag)
        return when (result) {
            is Either.Right -> response(content = result.value.toFavoriteLobbyOutputModel())

            is Either.Left -> when (result.value) {
                SetFavoriteError.LobbyNotFound ->
                    Problem.response(status = 404, problem = Problem.lobbyNotFound())
            }
        }
    }

    @PostMapping("/lobby/unfavorite")
    fun removeLobbyFavorite(user: User, @RequestBody lobby: LobbyTagInputModel): ResponseEntity<*> {
        val result = service.removeFavoriteLobby(user.id, lobby.tag)
        return when (result) {
            is Either.Right -> response(content = result.value.toFavoriteLobbyOutputModel())

            is Either.Left -> when (result.value) {
                SetFavoriteError.LobbyNotFound ->
                    Problem.response(status = 404, problem = Problem.lobbyNotFound())
            }
        }
    }

    private fun <T> response(content: T) = ResponseEntity
        .status(200)
        .header("Content-Type", "application/json")
        .body(content)
}