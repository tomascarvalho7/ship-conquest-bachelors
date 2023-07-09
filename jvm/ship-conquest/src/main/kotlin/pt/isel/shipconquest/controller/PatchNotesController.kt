package pt.isel.shipconquest.controller

import pt.isel.shipconquest.Either
import com.example.shipconquest.controller.model.Problem
import com.example.shipconquest.controller.model.output.toPatchNotesOutputModel
import com.example.shipconquest.domain.user.User
import com.example.shipconquest.service.PatchNotesService
import com.example.shipconquest.service.result.GetPatchNotesError
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

@RestController
class PatchNotesController(val service: PatchNotesService) {

    @GetMapping("/patch-notes")
    fun getPatchNotes(user: User): ResponseEntity<*> {
        val result =  service.getPatchNotes()

        return when (result) {
            is pt.isel.shipconquest.Either.Right -> response(content = result.value.toPatchNotesOutputModel())
            is pt.isel.shipconquest.Either.Left -> when(result.value) {
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