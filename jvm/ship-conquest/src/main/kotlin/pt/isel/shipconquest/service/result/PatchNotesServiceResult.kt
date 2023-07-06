package com.example.shipconquest.service.result

import com.example.shipconquest.Either
import com.example.shipconquest.domain.path_notes.PatchNotes

sealed class GetPatchNotesError {
    object PatchNotesNotFound: GetPatchNotesError()
}


typealias GetPatchNotesResult = Either<GetPatchNotesError, PatchNotes>