package pt.isel.shipconquest.controller.model.output

import pt.isel.shipconquest.domain.patch_notes.PatchNotes


data class PatchNotesOutputModel(val list: List<PatchNoteOutputModel>)

fun PatchNotes.toPatchNotesOutputModel() = PatchNotesOutputModel(list = list.map { patchNote -> PatchNoteOutputModel(patchNote.title, patchNote.notes) } )