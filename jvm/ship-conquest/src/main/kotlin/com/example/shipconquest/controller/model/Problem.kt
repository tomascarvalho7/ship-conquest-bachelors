package com.example.shipconquest.controller.model

import org.springframework.http.ResponseEntity

data class Problem(val title: String, val detail: String) {
    companion object {
        // the problem json media type representation to use in http header
        private const val MEDIA_TYPE = "application/problem+json"

        fun response(status: Int, problem: Problem) = ResponseEntity
            .status(status)
            .header("Content-Type", MEDIA_TYPE)
            .body(problem)

        fun lobbyNotFound() = Problem(
            title = "Lobby not found",
            detail = "The lobby resource identified was not found."
        )

        fun invalidLobbyName() = Problem(
            title = "Invalid lobby name",
            detail = "The name entered does not match the lobby name rules defined, " +
                    "the lobby name must have between 4 and 16 characters."
        )

        fun gameNotFound() = Problem(
            title = "Game not found",
            detail = "The game resource identified was not found."
        )

        fun shipPositionNotFound() = Problem(
            title = "Ship position record doesn't exist",
            detail = "There is no record of a ship with the given id belonging to you in the given lobby."
        )

        fun invalidIdToken() = Problem(
            title = "ID Token is invalid",
            detail = "The ID Token you presented as invalid and authentication failed."
        )

        fun tokenCreationFailed() = Problem(
            title = "Failed to create a token",
            detail = "Failed to create a token, please try again."
        )

        fun noTrackedRecord() =  Problem(
            title = "There seems to be no record tracked from you",
            detail = "There is no record from your boats in this game."
        )

        fun invalidNavigation() = Problem(
            title = "Invalid navigation path",
            detail = "The navigation path you described isn't valid."
        )

        fun shipNotFound() = Problem(
            title = "Ship not found",
            detail = "The ship you looked for was not found."
        )
    }
}

