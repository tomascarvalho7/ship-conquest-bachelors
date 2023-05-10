package com.example.shipconquest.repo.jdbi.mapper

import com.example.shipconquest.repo.jdbi.ShipRepositoryJDBI
import com.example.shipconquest.repo.jdbi.dbmodel.ShipMovementDBModel
import org.jdbi.v3.core.mapper.ColumnMapper
import org.jdbi.v3.core.statement.StatementContext
import org.postgresql.util.PGobject
import java.sql.ResultSet

class ShipPositionMapper: ColumnMapper<ShipMovementDBModel> {
    override fun map(r: ResultSet, columnNumber: Int, ctx: StatementContext?): ShipMovementDBModel? {
        val obj = r.getObject(columnNumber, PGobject::class.java)
        val value = obj.value;
        return if (value != null) ShipRepositoryJDBI.deserializeShipPosition(value)
        else null
    }
}
