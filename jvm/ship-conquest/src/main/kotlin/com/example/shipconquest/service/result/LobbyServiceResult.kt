package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.domain.lobby.Lobby

sealed class GetLobbyError {
    object LobbyNotFound: GetLobbyError()
}

typealias GetLobbyResult = Either<GetLobbyError, Lobby>

sealed class CreateLobbyError {
    object InvalidServerName: CreateLobbyError()
}

typealias CreateLobbyResult = Either<CreateLobbyError, String>


sealed class JoinLobbyError {
    object LobbyNotFound: JoinLobbyError()
}

typealias JoinLobbyResult = Either<JoinLobbyError, String>

sealed class GetAllLobbiesError {
    object InvalidOrderParameter: GetAllLobbiesError()
}

typealias GetAllLobbiesResult = Either<GetAllLobbiesError, List<Lobby>>