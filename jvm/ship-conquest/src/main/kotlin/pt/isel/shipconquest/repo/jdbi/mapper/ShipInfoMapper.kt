package pt.isel.shipconquest.repo.jdbi.mapper

import org.jdbi.v3.core.mapper.ColumnMapper
import org.jdbi.v3.core.statement.StatementContext
import pt.isel.shipconquest.repo.jdbi.ShipRepositoryJDBI
import pt.isel.shipconquest.repo.jdbi.dbmodel.ShipInfoDBModel
import java.sql.ResultSet
import java.time.Duration

class ShipInfoMapper : ColumnMapper<ShipInfoDBModel> {
    override fun map(r: ResultSet, columnNumber: Int, ctx: StatementContext?): ShipInfoDBModel? {
        val shipId = r.getInt(columnNumber)
        val pointsJson = r.getString(columnNumber + 1)
        val startTimeTimestamp = r.getTimestamp(columnNumber + 2)
        val startTime = startTimeTimestamp?.toInstant()
        val durationSeconds = r.getInt(columnNumber + 3)
        val duration = if (durationSeconds != 0) Duration.ofSeconds(durationSeconds.toLong()) else null

        val points = ShipRepositoryJDBI.deserializeShipPosition(pointsJson)
        return ShipInfoDBModel(shipId, points, startTime, duration)
    }
}