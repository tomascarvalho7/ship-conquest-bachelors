package pt.isel.shipconquest.domain

/**
 * Factor data class holds a [value] that
 * must be between 0 and 100.
 */
data class Factor(val value: Int) {
    init {
        require(value in 0..100)
    }
}