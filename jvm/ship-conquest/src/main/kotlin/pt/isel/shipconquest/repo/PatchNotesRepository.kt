package pt.isel.shipconquest.repo

import org.slf4j.Logger
import pt.isel.shipconquest.domain.patch_notes.PatchNotes

interface PatchNotesRepository {
    val logger: Logger
    fun getPatchNotes(): PatchNotes?
}