package com.example.shipconquest

sealed interface Either<out L, out R> {
    data class Left<L>(val value: L): Either<L, Nothing>
    data class Right<R>(val value: R): Either<Nothing, R>
}

fun <L> left(value: L) = Either.Left(value)
fun <R> right(value: R) = Either.Right(value)