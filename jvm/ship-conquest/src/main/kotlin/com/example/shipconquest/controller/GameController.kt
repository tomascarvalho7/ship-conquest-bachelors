package com.example.shipconquest.controller

import com.example.shipconquest.Either
import com.example.shipconquest.controller.model.Problem
import com.example.shipconquest.controller.model.input.ConquestInputModel
import com.example.shipconquest.controller.model.input.NavigationPathInputModel
import com.example.shipconquest.controller.model.output.*
import com.example.shipconquest.controller.model.output.ship.toFleetOutputModel
import com.example.shipconquest.controller.model.output.ship.toShipOutputModel
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.service.GameService
import com.example.shipconquest.service.result.*
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter

@RestController
class GameController(val service: GameService) {

    @GetMapping("/{tag}/view")
    fun view(user: User, @PathVariable tag: String, @RequestParam shipId: Int): ResponseEntity<*> {
        val result = service.getChunks(tag = tag, shipId = shipId, uid = user.id)

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

    @GetMapping("/{tag}/statistics")
    fun getStatistics(user: User, @PathVariable tag: String): ResponseEntity<*> {
        val result = service.getPlayerStats(tag = tag, uid = user.id)

        return when (result) {
            is Either.Right -> response(content = result.value.toPlayerStatisticsOutputModel())
            is Either.Left -> when(result.value) {
                GetPlayerStatsError.GameNotFound ->
                    Problem.response(status = 404, problem = Problem.gameNotFound())
                GetPlayerStatsError.StatisticsNotFound ->
                    Problem.response(status = 404, problem = Problem.statisticsNotFound())
            }
        }
    }

    @PostMapping("/{tag}/conquest")
    fun conquest(user: User, @PathVariable tag: String, @RequestBody input: ConquestInputModel): ResponseEntity<*> {
        val result = service.conquestIsland(tag, user.id, input.shipId, input.islandId);

        return when(result) {
            is Either.Right -> response(content = result.value.toOwnedIslandOutputModel())
            is Either.Left -> when (result.value) {
                ConquestIslandError.GameNotFound ->
                    Problem.response(status = 404, problem = Problem.gameNotFound())
                ConquestIslandError.ShipNotFound ->
                    Problem.response(status = 404, problem = Problem.shipNotFound())
                ConquestIslandError.IslandNotFound ->
                    Problem.response(status = 404, problem = Problem.islandNotFound())
                ConquestIslandError.PlayerStatisticsNotFound ->
                    Problem.response(status = 404, problem = Problem.statisticsNotFound())
                ConquestIslandError.AlreadyOwnedIsland ->
                    Problem.response(status = 400, problem = Problem.alreadyOwnedIsland())
                ConquestIslandError.NotEnoughCurrency ->
                    Problem.response(status = 400, problem = Problem.notEnoughCurrency())
                ConquestIslandError.ShipTooFarAway ->
                    Problem.response(status = 400, problem = Problem.shipTooFarAway())
            }
        }
    }

    @GetMapping("/{tag}/minimap")
    fun getMinimap(user: User, @PathVariable tag: String): ResponseEntity<*> {
        val result = service.getMinimap(tag = tag, uid = user.id)

        return when (result) {
            is Either.Right -> response(content = result.value.toOutputModel())
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
        @RequestParam shipId: Int
    ): ResponseEntity<*> {
        val result = service.navigate(tag, user.id, shipId, bodyObj.points)

        return when (result) {
            is Either.Right -> {
                // publish and notify of new events
                ShipEventsAPI.publishEvents(tag = tag, futureEvents = result.value.futureEvents)
                // return sailing ship
                response(content = result.value.toShipOutputModel())
            }
            is Either.Left -> when (result.value) {
                NavigationError.InvalidNavigationPath ->
                    Problem.response(status = 400, problem = Problem.invalidNavigation())
                NavigationError.ShipNotFound ->
                    Problem.response(status = 404, problem = Problem.shipNotFound())
            }
        }
    }

    @GetMapping("/{tag}/ship")
    fun getShip(
        user: User,
        @PathVariable tag: String,
        @RequestParam shipId: Int
    ): ResponseEntity<*> {
        val result = service.getShip(tag = tag, uid = user.id, shipId = shipId)

        return when (result) {
            is Either.Right -> response(content = result.value.toShipOutputModel())
            is Either.Left -> when (result.value) {
                GetShipError.ShipNotFound ->
                    Problem.response(status = 404, problem = Problem.shipNotFound())
            }
        }
    }

    @GetMapping("/{tag}/ships")
    fun getShips(user: User, @PathVariable tag: String): ResponseEntity<*> {
        val result = service.getShips(tag = tag, uid = user.id)

        return when (result) {
            is Either.Right -> response(content = result.value.toFleetOutputModel())
            is Either.Left -> TODO("bruh")
        }
    }

    @GetMapping("/{tag}/islands/known")
    fun getKnownIslands(
        user: User,
        @PathVariable tag: String
    ): ResponseEntity<*>  {
        val result = service.getKnownIslands(tag, user.id)

        return when(result) {
            is Either.Right -> response(result.value.toIslandListOutputModel())
            is Either.Left -> when(result.value) {
                GetKnownIslandsError.GameNotFound ->
                    Problem.response(status = 404, problem = Problem.gameNotFound())
            }
        }
    }

    @GetMapping("/{tag}/subscribe", MediaType.TEXT_EVENT_STREAM_VALUE)
    fun subscribe(user: User, @PathVariable tag: String): SseEmitter {
        val result = service.getShips(tag = tag, uid = user.id)

        return when (result) {
            is Either.Right -> {
                val emitter = ShipEventsAPI.subscribeToFleetEvents(tag = tag, uid = user.id, fleet = result.value)
                //emitter.send(result.value.toFleetOutputModel())
                return emitter
            }
            is Either.Left -> TODO("bruh")
        }
    }

    @GetMapping("/{tag}/unsubscribe")
    fun unsubscribe(user: User, @PathVariable tag: String): ResponseEntity<*> {
        ShipEventsAPI.unsubscribeToFleetEvents(tag = tag, uid = user.id)
        return response("placeholder content") // TODO:
    }

    private fun <T> response(content: T) = ResponseEntity
        .status(200)
        .header("Content-Type", "application/json")
        .body(content)
}