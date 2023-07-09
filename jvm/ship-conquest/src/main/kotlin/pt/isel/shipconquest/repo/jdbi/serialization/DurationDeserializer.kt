package pt.isel.shipconquest.repo.jdbi.serialization

import com.fasterxml.jackson.core.JsonParser
import com.fasterxml.jackson.databind.DeserializationContext
import com.fasterxml.jackson.databind.JsonDeserializer
import java.time.Duration


class DurationDeserializer : JsonDeserializer<Duration>() {
    override fun deserialize(p: JsonParser, ctxt: DeserializationContext): Duration {
        val durationString = p.text
        return Duration.parse(durationString)
    }
}