package pt.isel.shipconquest.service.result

import pt.isel.shipconquest.Either
import com.example.shipconquest.domain.lobby.Lobby
import com.example.shipconquest.domain.lobby.LobbyInfo

sealed class GetLobbyError {
    object LobbyNotFound: GetLobbyError()
}

typealias GetLobbyResult = pt.isel.shipconquest.Either<GetLobbyError, Lobby>

sealed class CreateLobbyError {
    object InvalidServerName: CreateLobbyError()
}

typealias CreateLobbyResult = pt.isel.shipconquest.Either<CreateLobbyError, String>


sealed class JoinLobbyError {
    object LobbyNotFound: JoinLobbyError()
}

typealias JoinLobbyResult = pt.isel.shipconquest.Either<JoinLobbyError, String>

sealed class GetLobbyListError {
    object InvalidOrderParameter: GetLobbyListError()
}

typealias GetAllLobbiesResult = pt.isel.shipconquest.Either<GetLobbyListError, List<LobbyInfo>>

sealed class SetFavoriteError {
    object LobbyNotFound: SetFavoriteError()
}

typealias FavoriteOperationResult = pt.isel.shipconquest.Either<SetFavoriteError, Boolean>