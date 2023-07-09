package pt.isel.shipconquest.service

import org.slf4j.Logger
import pt.isel.shipconquest.repo.TransactionManager

interface ServiceModule {
    val logger: Logger
    val transactionManager: TransactionManager
}