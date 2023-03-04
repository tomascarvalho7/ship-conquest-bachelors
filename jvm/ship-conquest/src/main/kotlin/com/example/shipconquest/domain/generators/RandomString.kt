package com.example.shipconquest.domain.generators

object RandomString {
    private const val characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

    fun generate(length: Int) = buildString {
        // append random characters n times to string
        for (n in 0 until length)
            append(characters.random())
    }
}