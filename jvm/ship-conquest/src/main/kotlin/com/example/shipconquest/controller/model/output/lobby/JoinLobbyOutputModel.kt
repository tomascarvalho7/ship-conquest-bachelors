package com.example.shipconquest.controller.model.output.lobby

data class JoinLobbyOutputModel(val tag: String) {
    val info: String = "Joined lobby with tag = $tag."
}