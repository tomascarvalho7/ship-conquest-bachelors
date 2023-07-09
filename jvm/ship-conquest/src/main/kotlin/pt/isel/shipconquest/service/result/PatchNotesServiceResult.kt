package pt.isel.shipconquest.service.result

import pt.isel.shipconquest.Either
import com.example.shipconquest.domain.path_notes.PatchNotes

sealed class GetPatchNotesError {
    object PatchNotesNotFound: GetPatchNotesError()
}


typealias GetPatchNotesResult = pt.isel.shipconquest.Either<GetPatchNotesError, PatchNotes>