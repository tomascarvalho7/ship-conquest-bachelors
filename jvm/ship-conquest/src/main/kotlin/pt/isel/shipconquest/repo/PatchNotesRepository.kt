package pt.isel.shipconquest.repo

import com.example.shipconquest.domain.path_notes.PatchNotes
import org.slf4j.Logger

interface PatchNotesRepository {
    val logger: Logger
    fun getPatchNotes(): PatchNotes?
}