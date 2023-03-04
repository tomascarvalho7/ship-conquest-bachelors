package com.example.shipconquest

import com.example.shipconquest.repo.jdbi.mapper.HeightMapMapper
import org.jdbi.v3.core.Jdbi
import org.jdbi.v3.core.kotlin.KotlinPlugin
import org.jdbi.v3.postgres.PostgresPlugin

// configure JDBI
fun Jdbi.configure(): Jdbi {
    installPlugin(KotlinPlugin())
    installPlugin(PostgresPlugin())

    registerColumnMapper(HeightMapMapper())
    return this
}
