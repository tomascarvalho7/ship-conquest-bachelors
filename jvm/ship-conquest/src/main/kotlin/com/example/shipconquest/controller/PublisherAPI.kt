package com.example.shipconquest.controller

import org.springframework.web.servlet.mvc.method.annotation.SseEmitter

/**
 * Pub/Sub model to implement SSE (Server Sent Events)
 */
object PublisherAPI {
    // uid (User Identifiers) -> SSE Emitter
    private var subscriptions = mapOf<String, SseEmitter>()

    fun publish(key: String, message: Any) {
        subscriptions[key]?.send(message)
    }

    fun subscribe(key: String): SseEmitter {
        val sse = SseEmitter()
        subscriptions = subscriptions.plus(key to sse)
        return sse
    }

    fun unsubscribe(key: String) {
        subscriptions[key]?.complete() // close stream
        subscriptions = subscriptions.minus(key)
    }
}