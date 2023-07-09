package pt.isel.shipconquest.domain.user

/**
 * The [UserInfo] data class holds the complete user data for presentation purposes
 */
data class UserInfo(
    val username: String,
    val name: String,
    val email: String,
    val imageUrl: String?,
    val description: String?
)