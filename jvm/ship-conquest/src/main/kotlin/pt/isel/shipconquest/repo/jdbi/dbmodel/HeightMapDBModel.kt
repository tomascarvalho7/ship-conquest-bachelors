package pt.isel.shipconquest.repo.jdbi.dbmodel

import pt.isel.shipconquest.domain.space.Vector2
import pt.isel.shipconquest.domain.world.HeightMap


data class HeightMapDBModel(val size: Int, val data: Map<Int, Int>)

fun HeightMap.toHeightMapDBModel() =
    HeightMapDBModel(
        size = size,
        // simplify map to only primitives, transform pos(x, y) => z(index)
        data = data.mapKeys { (pos, _) ->
            pos.x + pos.y * size
        }
    )

fun HeightMapDBModel.toHeightMap() =
    HeightMap(
        size = size,
        data = data.mapKeys { (index, _) ->
            Vector2(
                x = index % size,
                y = index.floorDiv(size)
            )
        }
    )