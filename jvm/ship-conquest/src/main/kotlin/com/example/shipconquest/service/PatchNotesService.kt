package com.example.shipconquest.service

import com.example.shipconquest.left
import com.example.shipconquest.repo.TransactionManager
import com.example.shipconquest.right
import com.example.shipconquest.service.result.GetPatchNotesError
import com.example.shipconquest.service.result.GetPatchNotesResult
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service

@Service
class PatchNotesService(
    override val transactionManager: TransactionManager,
): ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun getPatchNotes(): GetPatchNotesResult {
        return transactionManager.run { transaction ->
            val patchNotes = transaction.patchNotesRepo.getPatchNotes() ?: return@run left(GetPatchNotesError.PatchNotesNotFound)
            return@run right(patchNotes)
        }
    }
}