package pt.isel.shipconquest.domain.user

/**
 * The [Token] data class holds the user bearer token data.
 */
data class Token(val value: String)

// [Token] builder function
fun String.toToken(): Token {
    return Token(this)
}
