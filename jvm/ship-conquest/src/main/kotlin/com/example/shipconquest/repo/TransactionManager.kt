package com.example.shipconquest.repo

interface TransactionManager {
    // create and run a transaction
    fun <R> run(block: (Transaction) -> R): R
}