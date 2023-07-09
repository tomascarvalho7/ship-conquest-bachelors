package pt.isel.shipconquest

import org.jdbi.v3.core.Jdbi
import org.jdbi.v3.core.kotlin.KotlinPlugin
import org.jdbi.v3.postgres.PostgresPlugin
import pt.isel.shipconquest.repo.jdbi.mapper.*

// configure JDBI
fun Jdbi.configure(): Jdbi {
    installPlugin(KotlinPlugin())
    installPlugin(PostgresPlugin())

    registerColumnMapper(InstantMapper())
    registerColumnMapper(HeightMapMapper())
    registerColumnMapper(PositionListMapper())
    registerColumnMapper(PositionMapper())
    registerColumnMapper(CubicBezierMapper())
    registerColumnMapper(CubicBezierListMapper())
    registerColumnMapper(ShipPositionMapper())
    registerColumnMapper(ShipInfoMapper())
    return this
}
