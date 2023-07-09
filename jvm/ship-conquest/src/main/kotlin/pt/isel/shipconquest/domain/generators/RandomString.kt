package pt.isel.shipconquest.domain.generators

/**
 * Singleton generator to generate a random string with limited characters.
 */
object RandomString {
    private const val characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    // generate a random string with a given [length]
    fun generate(length: Int) = buildString {
        // append random characters n times to string
        for (n in 0 until length)
            append(characters.random())
    }
}