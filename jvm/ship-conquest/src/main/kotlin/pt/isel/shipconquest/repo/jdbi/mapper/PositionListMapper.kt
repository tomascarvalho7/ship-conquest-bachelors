package com.example.shipconquest.repo.jdbi.mapper

import com.example.shipconquest.repo.jdbi.GameRepositoryJDBI
import com.example.shipconquest.repo.jdbi.dbmodel.PositionDBModel
import org.jdbi.v3.core.mapper.ColumnMapper
import org.jdbi.v3.core.statement.StatementContext
import org.postgresql.util.PGobject
import java.sql.ResultSet

class PositionListMapper: ColumnMapper<Array<PositionDBModel>> {
    override fun map(r: ResultSet, columnNumber: Int, ctx: StatementContext?): Array<PositionDBModel> {
        val obj = r.getObject(columnNumber, PGobject::class.java)
        return GameRepositoryJDBI.deserializePositionList(obj.value ?: throw IllegalStateException())
    }
}