package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.domain.lobby.CompleteLobby
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

sealed class GetLobbyListError {
    object InvalidOrderParameter: GetLobbyListError()
}

typealias GetAllLobbiesResult = Either<GetLobbyListError, List<CompleteLobby>>

sealed class SetFavoriteError {
    object LobbyNotFound: SetFavoriteError()
}

typealias FavoriteOperationResult = Either<SetFavoriteError, Boolean>