package pt.isel.shipconquest.service

import pt.isel.shipconquest.left
import com.example.shipconquest.repo.TransactionManager
import pt.isel.shipconquest.right
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
            val patchNotes = transaction.patchNotesRepo.getPatchNotes() ?: return@run pt.isel.shipconquest.left(
                GetPatchNotesError.PatchNotesNotFound
            )
            return@run pt.isel.shipconquest.right(patchNotes)
        }
    }
}