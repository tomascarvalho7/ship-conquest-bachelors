package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.path_notes.PatchNote
import com.example.shipconquest.domain.path_notes.PatchNotes

data class PatchNoteDBModel(val title: String, val details: String)

fun List<PatchNoteDBModel>.toPatchNotes(): PatchNotes? {
    return if (this.isEmpty()) null
    else PatchNotes( list = map { patchNote -> PatchNote(patchNote.title, patchNote.details.split("\n")) } )
}