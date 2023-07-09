package pt.isel.shipconquest.controller.model.output.lobby


data class LobbyInfoListOutputModel(val lobbies: List<LobbyInfoOutputModel>)

fun List<LobbyInfoOutputModel>.toLobbyInfoListOutputModel() =
    LobbyInfoListOutputModel(this)