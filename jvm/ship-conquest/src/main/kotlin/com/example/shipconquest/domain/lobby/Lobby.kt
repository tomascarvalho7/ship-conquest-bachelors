package com.example.shipconquest.domain.lobby

import java.time.Instant

data class Lobby(val tag: String, val name: String, val uid: String,  val username: String, val creationTime: Long)