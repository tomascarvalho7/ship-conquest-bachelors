package com.example.shipconquest.controller

import com.example.shipconquest.Either
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