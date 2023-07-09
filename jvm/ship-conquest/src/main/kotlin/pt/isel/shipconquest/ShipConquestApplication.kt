package pt.isel.shipconquest

import org.jdbi.v3.core.Jdbi
import org.postgresql.PGProperty
import org.postgresql.ds.PGSimpleDataSource
import org.slf4j.LoggerFactory
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean

private val logger = LoggerFactory.getLogger(pt.isel.shipconquest.ShipConquestApplication::class.java)

/**
 * Bean definitions for the application
 */
@SpringBootApplication
class ShipConquestApplication {
	@Bean
	fun getJdbi(): Jdbi {
		val postgresUri = System.getenv("POSTGRES_URI") ?: "jdbc:postgresql://localhost:5432/postgres?user=postgres&password=gui17"
		val dataSource = PGSimpleDataSource().apply {
			setURL(postgresUri)
		}

		logger.info(
			"Using PostgreSQL located at '{}:{}'",
			dataSource.getProperty(PGProperty.PG_HOST),
			dataSource.getProperty(PGProperty.PG_PORT)
		)

		return Jdbi.create(dataSource).configure()
	}

	@Bean
	fun getClock() = RealClock
}

fun main(args: Array<String>) {
	runApplication<ShipConquestApplication>(*args)
}
