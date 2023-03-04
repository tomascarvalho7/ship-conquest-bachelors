package com.example.shipconquest.service

import com.example.shipconquest.repo.TransactionManager
import org.slf4j.Logger

interface ServiceModule {
    val logger: Logger
    val transactionManager: TransactionManager
}