package com.example.shipconquest

import com.example.shipconquest.repo.jdbi.mapper.*
import org.jdbi.v3.core.Jdbi
import org.jdbi.v3.core.kotlin.KotlinPlugin
import org.jdbi.v3.postgres.PostgresPlugin

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
    return this
}
