package pt.isel.shipconquest.domain.lobby

/**
 * The [LobbyInfo] data class holds the data for the complete set of
 * information available for a lobby.
 */
data class LobbyInfo(
    val tag: String,
    val name: String,
    val uid: String,
    val username: String,
    val creationTime: Long,
    val isFavorite: Boolean,
    val lobbyCount: Int
)