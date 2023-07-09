package pt.isel.shipconquest.repo.jdbi.mapper

import org.jdbi.v3.core.mapper.ColumnMapper
import org.jdbi.v3.core.statement.StatementContext
import org.postgresql.util.PGobject
import pt.isel.shipconquest.repo.jdbi.GameRepositoryJDBI
import pt.isel.shipconquest.repo.jdbi.dbmodel.PositionDBModel
import java.sql.ResultSet

class PositionListMapper: ColumnMapper<Array<PositionDBModel>> {
    override fun map(r: ResultSet, columnNumber: Int, ctx: StatementContext?): Array<PositionDBModel> {
        val obj = r.getObject(columnNumber, PGobject::class.java)
        return GameRepositoryJDBI.deserializePositionList(obj.value ?: throw IllegalStateException())
    }
}