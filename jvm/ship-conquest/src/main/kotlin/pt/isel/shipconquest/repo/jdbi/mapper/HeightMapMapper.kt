package pt.isel.shipconquest.repo.jdbi.mapper

import org.jdbi.v3.core.mapper.ColumnMapper
import org.jdbi.v3.core.statement.StatementContext
import org.postgresql.util.PGobject
import pt.isel.shipconquest.repo.jdbi.GameRepositoryJDBI
import pt.isel.shipconquest.repo.jdbi.dbmodel.HeightMapDBModel
import java.sql.ResultSet

class HeightMapMapper: ColumnMapper<HeightMapDBModel> {
    override fun map(r: ResultSet, columnNumber: Int, ctx: StatementContext?): HeightMapDBModel {
        val obj = r.getObject(columnNumber, PGobject::class.java)
        return GameRepositoryJDBI.deserializeGameMap(obj.value ?: throw IllegalStateException())
    }
}