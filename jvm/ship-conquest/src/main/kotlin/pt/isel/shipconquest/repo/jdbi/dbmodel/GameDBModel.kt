package com.example.shipconquest.repo.jdbi.dbmodel

import com.example.shipconquest.domain.game.Game

data class GameDBModel(val tag: String, val map: HeightMapDBModel)

fun GameDBModel.toGame(): Game = Game(tag = tag, map = map.toHeightMap())