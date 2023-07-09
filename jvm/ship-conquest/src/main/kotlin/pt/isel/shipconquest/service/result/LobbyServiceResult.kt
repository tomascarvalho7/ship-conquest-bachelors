package pt.isel.shipconquest.service.result

import pt.isel.shipconquest.Either
import pt.isel.shipconquest.domain.lobby.Lobby
import pt.isel.shipconquest.domain.lobby.LobbyInfo

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

typealias GetAllLobbiesResult = Either<GetLobbyListError, List<LobbyInfo>>

sealed class SetFavoriteError {
    object LobbyNotFound: SetFavoriteError()
}

typealias FavoriteOperationResult = Either<SetFavoriteError, Boolean>