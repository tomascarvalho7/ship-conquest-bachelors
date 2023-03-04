package com.example.shipconquest.controller

import com.example.shipconquest.Either
import com.example.shipconquest.controller.model.Problem
import com.example.shipconquest.controller.model.output.HorizonOutputModel
import com.example.shipconquest.domain.Position
import com.example.shipconquest.domain.Vector3
import com.example.shipconquest.service.GameService
import com.example.shipconquest.service.result.GetChunksError
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController

@RestController
class GameController(val service: GameService) {
    /**
     * name to be either view, glance, or inspectHorizon
     */
    @GetMapping("/{tag}/view")
    fun view(@PathVariable tag: String, @RequestParam x: Int, @RequestParam y: Int): ResponseEntity<*> {
        val result = service.getChunks(tag = tag, x = x, y = y)

        return when (result) {
            is Either.Right -> response(content = HorizonOutputModel(tiles = result.value))
            is Either.Left -> when(result.value) {
                GetChunksError.GameNotFound ->
                    Problem.response(status = 404, problem = Problem.gameNotFound())
            }
        }
    }

    private fun <T> response(content: T) = ResponseEntity
        .status(200)
        .header("Content-Type", "application/json")
        .body(content)
}