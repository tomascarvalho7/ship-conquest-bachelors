package com.example.shipconquest.domain.user

data class Token(val value: String)

fun String.toToken(): Token {
    return Token(this)
}
