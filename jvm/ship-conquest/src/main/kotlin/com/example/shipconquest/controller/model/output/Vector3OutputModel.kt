package com.example.shipconquest.controller.model.output

import com.example.shipconquest.domain.space.Vector3

data class Vector3OutputModel (val x: Int, val y: Int, val z: Int)

fun Vector3.toVector3OutputModel() = Vector3OutputModel(x = x, y = y, z = z)