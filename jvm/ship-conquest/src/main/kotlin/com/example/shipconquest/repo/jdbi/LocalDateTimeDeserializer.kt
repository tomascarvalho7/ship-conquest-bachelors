package com.example.shipconquest.repo.jdbi

import com.fasterxml.jackson.core.JsonParser
import com.fasterxml.jackson.databind.DeserializationContext
import com.fasterxml.jackson.databind.JsonDeserializer
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class LocalDateTimeDeserializer : JsonDeserializer<LocalDateTime>() {
    override fun deserialize(p: JsonParser, ctxt: DeserializationContext): LocalDateTime {
        val formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME
        val dateString = p.text
        return LocalDateTime.parse(dateString, formatter)
    }
}