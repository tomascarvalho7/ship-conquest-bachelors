package com.example.shipconquest.controller.sse.publisher

import org.springframework.http.MediaType
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyEmitter
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter.SseEventBuilder
import java.util.concurrent.ConcurrentHashMap

/**
 * Pub/Sub model to implement SSE (Server Sent Events)
 */
class Publisher(private val subscriptions: ConcurrentHashMap<String, SseEmitter>): PublisherAPI {

    override fun publish(key: String, message: Any) {
        subscriptions[key]?.send(message)
    }

    override fun subscribe(key: String): SseEmitter {
        val sse = SseEmitter(-1L) // set no timeout
        subscriptions.putIfAbsent(key, sse)
        return sse
    }

    override fun unsubscribe(key: String): String {
        subscriptions[key]?.complete() // close stream
        subscriptions.remove(key)
        return key
    }

    override fun createEvent(id: String, name: String, data: Any): MutableSet<ResponseBodyEmitter.DataWithMediaType> =
        SseEmitter
            .event()
            .id(id)
            .name(name)
            .data(data, MediaType.APPLICATION_JSON)
            .build()
}