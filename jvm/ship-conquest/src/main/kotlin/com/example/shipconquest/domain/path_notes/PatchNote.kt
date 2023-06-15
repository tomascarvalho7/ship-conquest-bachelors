package com.example.shipconquest.domain.path_notes

/**
 * The [PatchNote] class holds the data for the patch note details
 * from a released version of the current project.
 */
data class PatchNote(val title: String, val notes: List<String>)