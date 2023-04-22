package com.example.shipconquest.controller

import com.example.shipconquest.Either
import com.example.shipconquest.controller.model.Problem
import com.example.shipconquest.controller.model.input.NavigationPathInputModel
import com.example.shipconquest.controller.model.output.*
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.service.GameService
import com.example.shipconquest.service.result.*
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*

@RestController
class GameController(val service: GameService) {
    /**
     * name to be either view, glance, or inspectHorizon
     */
    @GetMapping("/{tag}/view")
    fun view(user: User, @PathVariable tag: String, @RequestParam shipId: String): ResponseEntity<*> {
        val result = service.getChunks(tag = tag, shipId = shipId, googleId = user.id)

        return when (result) {
            is Either.Right -> response(content = result.value.toHorizonOutputModel())
            is Either.Left -> when (result.value) {
                GetChunksError.GameNotFound ->
                    Problem.response(status = 404, problem = Problem.gameNotFound())

                GetChunksError.ShipPositionNotFound ->
                    Problem.response(status = 404, problem = Problem.shipPositionNotFound())
            }
        }
    }

    @GetMapping("{tag}/print")
    fun print(@PathVariable tag: String) {
        service.printMap(tag)
    }

    @GetMapping("/{tag}/minimap")
    fun getMinimap(user: User, @PathVariable tag: String): ResponseEntity<*> { // needs authorization to get uid
        val result = service.getMinimap(tag = tag, uid = user.id)

        return when (result) {
            is Either.Right -> response(content = MinimapOutputModel(points = result.value, size = result.value.size))
            is Either.Left -> when (result.value) {
                GetMinimapError.GameNotFound ->
                    Problem.response(status = 404, problem = Problem.gameNotFound())

                GetMinimapError.NoTrackedRecord ->
                    Problem.response(status = 400, problem = Problem.noTrackedRecord())
            }
        }
    }

    @PostMapping("/{tag}/navigate")
    fun navigate(
        user: User,
        @PathVariable tag: String,
        @RequestBody bodyObj: NavigationPathInputModel,
        @RequestParam shipId: String
    ): ResponseEntity<*> {
        val result = service.navigate(tag, user.id, shipId, bodyObj.points)

        return when (result) {
            is Either.Right -> response(
                content = ShipPathTimeOutputModel(
                    result.value.startTime,
                    result.value.duration
                )
            )

            is Either.Left -> when (result.value) {
                NavigationError.InvalidNavigationPath ->
                    Problem.response(status = 404, problem = Problem.invalidNavigation())
            }
        }
    }

    @GetMapping("/{tag}/ship/position")
    fun getShipPosition(
        user: User,
        @PathVariable tag: String,
        @RequestParam shipId: String
    ): ResponseEntity<*> { // needs authorization to get uid
        val result = service.getShipPosition(tag = tag, uid = user.id, shipId = shipId)

        return when (result) {
            is Either.Right -> response(content = PositionOutputModel(result.value.x, result.value.y))
            is Either.Left -> when (result.value) {
                GetShipPositionError.ShipNotFound ->
                    Problem.response(status = 404, problem = Problem.shipNotFound())
            }
        }
    }

    @GetMapping("/{tag}/ship/path")
    fun getShipPath(
        user: User,
        @PathVariable tag: String,
        @RequestParam shipId: String
    ): ResponseEntity<*> { // needs authorization to get uid
        val result = service.getShipPath(tag = tag, uid = user.id, shipId = shipId)

        return when (result) {
            is Either.Right -> response(
                content = ShipPathOutputModel(
                    result.value.landmarks,
                    result.value.startTime.toString(),
                    result.value.duration.toString()
                )
            )

            is Either.Left -> when (result.value) {
                GetShipPathError.ShipNotFound ->
                    Problem.response(status = 404, problem = Problem.shipNotFound())
            }
        }
    }

    private fun <T> response(content: T) = ResponseEntity
        .status(200)
        .header("Content-Type", "application/json")
        .body(content)
}