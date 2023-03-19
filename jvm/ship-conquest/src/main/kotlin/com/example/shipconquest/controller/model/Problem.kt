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

        fun invalidIdToken() = Problem(
            title = "ID Token is invalid",
            detail = "The ID Token you presented as invalid and authentication failed."
        )

        fun tokenCreationFailed() = Problem(
            title = "Failed to create a token",
            detail = "Failed to create a token, please try again."
        )
    }
}

