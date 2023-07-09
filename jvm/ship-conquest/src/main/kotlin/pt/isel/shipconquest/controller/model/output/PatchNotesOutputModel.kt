package pt.isel.shipconquest.controller.model.output

import com.example.shipconquest.domain.path_notes.PatchNotes

data class PatchNotesOutputModel(val list: List<PatchNoteOutputModel>)

fun PatchNotes.toPatchNotesOutputModel() = PatchNotesOutputModel(list = list.map { patchNote -> PatchNoteOutputModel(patchNote.title, patchNote.notes) } )