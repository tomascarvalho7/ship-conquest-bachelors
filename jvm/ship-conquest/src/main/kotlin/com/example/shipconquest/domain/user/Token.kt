package com.example.shipconquest.domain.user

import java.util.*

data class Token(val value: String)

fun Token.validate(): Boolean {
    return try {
        UUID.fromString(this.value)
        true
    } catch (e: IllegalArgumentException) {
        false
    }
}

fun String.toToken(): Token {
    return Token(this)
}
