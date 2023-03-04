package com.example.shipconquest.controller

import com.example.shipconquest.Either
import com.example.shipconquest.controller.model.Problem
import com.example.shipconquest.controller.model.input.LobbyInputModel
import com.example.shipconquest.controller.model.output.CreateLobbyOutputModel
import com.example.shipconquest.controller.model.output.LobbyOutputModel
import com.example.shipconquest.controller.model.output.toLobbyOutputModel
import com.example.shipconquest.service.LobbyService
import com.example.shipconquest.service.result.CreateLobbyError
import com.example.shipconquest.service.result.GetLobbyError
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
class LobbyController(val service: LobbyService) {
    @PostMapping("/create-lobby")
    fun createLobby(@RequestBody lobby: LobbyInputModel): ResponseEntity<*> {
        val result = service.createLobby(name = lobby.name)
        return when (result) {
            is Either.Right -> response(content = CreateLobbyOutputModel(tag = result.value))
            is Either.Left -> when (result.value) {
                CreateLobbyError.InvalidServerName ->
                    Problem.response(status = 400, problem = Problem.invalidLobbyName())
            }
        }
    }

    @GetMapping("/get-lobby")
    fun getLobby(@RequestParam tag: String): ResponseEntity<*> {
        val result  = service.getLobby(tag)
        return when(result) {
            is Either.Right -> response(content = result.value.toLobbyOutputModel())
            is Either.Left -> when(result.value) {
                GetLobbyError.LobbyNotFound ->
                    Problem.response(status = 404, problem = Problem.lobbyNotFound())
            }
        }
    }

    private fun <T> response(content: T) = ResponseEntity
        .status(200)
        .header("Content-Type", "application/json")
        .body(content)
}