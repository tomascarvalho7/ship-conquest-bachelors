package pt.isel.shipconquest.repo.jdbi.mapper

import org.jdbi.v3.core.mapper.ColumnMapper
import org.jdbi.v3.core.statement.StatementContext
import java.sql.ResultSet
import java.time.Instant

class InstantMapper : ColumnMapper<Instant> {
    override fun map(r: ResultSet, columnNumber: Int, ctx: StatementContext): Instant? {
        val value = r.getLong(columnNumber)
        if (value == 0L) return null
        return Instant.ofEpochSecond(value)
    }
}
