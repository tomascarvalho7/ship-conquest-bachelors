package pt.isel.shipconquest.controller

import pt.isel.shipconquest.Either
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController
import pt.isel.shipconquest.controller.model.Problem
import pt.isel.shipconquest.controller.model.output.toPatchNotesOutputModel
import pt.isel.shipconquest.domain.user.User
import pt.isel.shipconquest.service.PatchNotesService
import pt.isel.shipconquest.service.result.GetPatchNotesError

@RestController
class PatchNotesController(val service: PatchNotesService) {

    @GetMapping("/patch-notes")
    fun getPatchNotes(user: User): ResponseEntity<*> {
        val result =  service.getPatchNotes()

        return when (result) {
            is Either.Right -> response(content = result.value.toPatchNotesOutputModel())
            is Either.Left -> when(result.value) {
                GetPatchNotesError.PatchNotesNotFound ->
                    Problem.response(status = 404, problem = Problem.patchNotesNotFound())
            }
        }
    }

    private fun <T> response(content: T) = ResponseEntity
        .status(200)
        .header("Content-Type", "application/json")
        .body(content)
}