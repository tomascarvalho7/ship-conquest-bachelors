package com.example.shipconquest.repo.jdbi.mapper

import com.example.shipconquest.repo.jdbi.GameRepositoryJDBI
import com.example.shipconquest.repo.jdbi.dbmodel.ShipPositionDBModel
import org.jdbi.v3.core.mapper.ColumnMapper
import org.jdbi.v3.core.statement.StatementContext
import org.postgresql.util.PGobject
import java.sql.ResultSet

class ShipPositionMapper: ColumnMapper<ShipPositionDBModel> {
    override fun map(r: ResultSet, columnNumber: Int, ctx: StatementContext?): ShipPositionDBModel? {
        val obj = r.getObject(columnNumber, PGobject::class.java)
        val value = obj.value;
        return if (value != null) GameRepositoryJDBI.deserializeShipPosition(value)
        else null
    }
}