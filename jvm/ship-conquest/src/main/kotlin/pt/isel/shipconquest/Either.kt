package pt.isel.shipconquest

sealed interface Either<out L, out R> {
    data class Left<L>(val value: L): pt.isel.shipconquest.Either<L, Nothing>
    data class Right<R>(val value: R): pt.isel.shipconquest.Either<Nothing, R>
}

fun <L> left(value: L) = pt.isel.shipconquest.Either.Left(value)
fun <R> right(value: R) = pt.isel.shipconquest.Either.Right(value)