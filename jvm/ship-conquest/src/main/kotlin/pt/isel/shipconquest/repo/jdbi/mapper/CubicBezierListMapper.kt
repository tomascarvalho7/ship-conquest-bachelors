package pt.isel.shipconquest.repo.jdbi.mapper

import org.jdbi.v3.core.mapper.ColumnMapper
import org.jdbi.v3.core.statement.StatementContext
import org.postgresql.util.PGobject
import pt.isel.shipconquest.repo.jdbi.GameRepositoryJDBI
import pt.isel.shipconquest.repo.jdbi.dbmodel.CubicBezierDBModel
import java.sql.ResultSet

class CubicBezierListMapper: ColumnMapper<Array<CubicBezierDBModel>> {
    override fun map(r: ResultSet, columnNumber: Int, ctx: StatementContext?): Array<CubicBezierDBModel> {
        val obj = r.getObject(columnNumber, PGobject::class.java)
        return GameRepositoryJDBI.deserializeCubicBezierList(obj.value ?: throw IllegalStateException())
    }
}