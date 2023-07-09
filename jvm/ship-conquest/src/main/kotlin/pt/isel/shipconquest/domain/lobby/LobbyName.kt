package pt.isel.shipconquest.domain.lobby

/**
 * LobbyName is a string containing a name for a lobby that
 * complies with the rules set for a lobby name.
 */
data class LobbyName(val name: String)

// [LobbyName] builder function
fun String.toLobbyName(): LobbyName? {
    if (this.length !in 4..16) return null

    return LobbyName(name = this)
}