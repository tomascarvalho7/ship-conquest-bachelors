package pt.isel.shipconquest.repo.jdbi

import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.slf4j.Logger
import org.slf4j.LoggerFactory
import pt.isel.shipconquest.domain.patch_notes.PatchNotes
import pt.isel.shipconquest.repo.PatchNotesRepository
import pt.isel.shipconquest.repo.jdbi.dbmodel.PatchNoteDBModel
import pt.isel.shipconquest.repo.jdbi.dbmodel.toPatchNotes

class PatchNotesRepositoryJDBI(private val handle: Handle): PatchNotesRepository {
    override val logger: Logger = LoggerFactory.getLogger(this::class.java)

    override fun getPatchNotes(): PatchNotes? {
        logger.info("Getting patch notes from DB")

        return handle.createQuery(
            """
                select * from dbo.PatchNotes;
            """
        )
            .mapTo<PatchNoteDBModel>()
            .list()
            .toPatchNotes()
    }

}