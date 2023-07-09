package pt.isel.shipconquest.repo.jdbi

import com.example.shipconquest.domain.path_notes.PatchNotes
import com.example.shipconquest.repo.PatchNotesRepository
import com.example.shipconquest.repo.jdbi.dbmodel.PatchNoteDBModel
import com.example.shipconquest.repo.jdbi.dbmodel.toPatchNotes
import org.jdbi.v3.core.Handle
import org.jdbi.v3.core.kotlin.mapTo
import org.slf4j.Logger
import org.slf4j.LoggerFactory

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