package pt.isel.shipconquest.service

import org.slf4j.Logger
import org.slf4j.LoggerFactory
import org.springframework.stereotype.Service
import pt.isel.shipconquest.repo.TransactionManager
import pt.isel.shipconquest.service.result.GetPatchNotesError
import pt.isel.shipconquest.service.result.GetPatchNotesResult

@Service
class PatchNotesService(
    override val transactionManager: TransactionManager,
): ServiceModule {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    fun getPatchNotes(): GetPatchNotesResult {
        return transactionManager.run { transaction ->
            val patchNotes = transaction.patchNotesRepo.getPatchNotes() ?: return@run pt.isel.shipconquest.left(
                GetPatchNotesError.PatchNotesNotFound
            )
            return@run pt.isel.shipconquest.right(patchNotes)
        }
    }
}