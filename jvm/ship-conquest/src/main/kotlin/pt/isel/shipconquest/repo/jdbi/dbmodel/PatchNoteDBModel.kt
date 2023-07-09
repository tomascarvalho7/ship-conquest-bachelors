package pt.isel.shipconquest.repo.jdbi.dbmodel

import pt.isel.shipconquest.domain.patch_notes.PatchNote
import pt.isel.shipconquest.domain.patch_notes.PatchNotes

data class PatchNoteDBModel(val title: String, val details: String)

fun List<PatchNoteDBModel>.toPatchNotes(): PatchNotes? {
    return if (this.isEmpty()) null
    else PatchNotes( list = map { patchNote -> PatchNote(patchNote.title, patchNote.details.split("\n")) } )
}