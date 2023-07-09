package pt.isel.shipconquest.controller.model.output

data class UserInfoOutputModel(
    val username: String,
    val name: String,
    val email: String,
    val imageUrl: String?,
    val description: String?
)