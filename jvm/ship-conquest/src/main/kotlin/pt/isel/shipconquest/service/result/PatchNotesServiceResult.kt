package pt.isel.shipconquest.service.result

import pt.isel.shipconquest.Either
import pt.isel.shipconquest.domain.patch_notes.PatchNotes

sealed class GetPatchNotesError {
    object PatchNotesNotFound: GetPatchNotesError()
}


typealias GetPatchNotesResult = Either<GetPatchNotesError, PatchNotes>