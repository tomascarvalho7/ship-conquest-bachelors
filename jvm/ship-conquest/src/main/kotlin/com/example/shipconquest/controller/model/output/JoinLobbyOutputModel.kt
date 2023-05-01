package com.example.shipconquest.controller.model.output

data class JoinLobbyOutputModel(val tag: String) {
    val info: String = "Joined lobby with tag = $tag."
}