package pt.isel.shipconquest.controller.model.output

import pt.isel.shipconquest.domain.space.Vector3


data class Vector3OutputModel (val x: Int, val y: Int, val z: Int)

fun Vector3.toVector3OutputModel() = Vector3OutputModel(x = x, y = y, z = z)