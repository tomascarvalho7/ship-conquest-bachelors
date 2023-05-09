package com.example.shipconquest.domain.lobby
/**
 * Enum class representing an Order
 */
enum class Order {
    ASCENDING,
    DESCENDING
}

fun String?.toOrderOrNull(): Order? {
    return when (this) {
        null -> Order.DESCENDING
        "ascending" -> Order.ASCENDING
        "descending" -> Order.DESCENDING
        else -> null
    }
}

/**
 * Maps an Order to a SQL valid string
 */
fun Order.toSQLOrder(): String {
    return when (this) {
        Order.ASCENDING -> "ASC"
        Order.DESCENDING -> "DESC"
    }
}
