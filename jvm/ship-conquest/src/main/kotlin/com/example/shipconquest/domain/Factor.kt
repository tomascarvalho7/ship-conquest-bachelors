package com.example.shipconquest.domain

/**
 * Factor value must be between 0 and 100
 */
data class Factor(val value: Int) {
    init {
        require(value in 0..100)
    }
}