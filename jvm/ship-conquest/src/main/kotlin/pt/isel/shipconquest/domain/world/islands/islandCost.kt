package com.example.shipconquest.domain.world.islands

const val WildIslandCost = 100
const val OwnedIslandCost = 200
fun Island.getCost() = when (this) {
    is WildIsland -> WildIslandCost
    is OwnedIsland -> OwnedIslandCost
}