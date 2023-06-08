package com.example.shipconquest.controller.sse.publisher

import org.springframework.web.servlet.mvc.method.annotation.SseEmitter

interface PublisherAPI {
    fun publish(key: String, message: Any)

    fun subscribe(key: String): SseEmitter

    fun unsubscribe(key: String): String

    fun createEvent(id: String, name: String, data: Any): SseEmitter.SseEventBuilder
}