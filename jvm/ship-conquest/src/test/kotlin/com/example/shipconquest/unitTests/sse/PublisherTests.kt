package com.example.shipconquest.unitTests.sse

import com.example.shipconquest.controller.sse.publisher.Publisher
import org.junit.jupiter.api.Assertions.assertEquals
import org.junit.jupiter.api.Assertions.assertNull
import org.junit.jupiter.api.Test
import org.mockito.Mockito.mock
import org.mockito.Mockito.verify
import org.springframework.http.MediaType
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter
import java.util.concurrent.ConcurrentHashMap

class PublisherTests {
    @Test
    fun `publish should send message to subscribed emitter`() {
        // setup
        val key = "user1"
        val message = "Hello, world!"
        // create a mock for the SsEmitter class
        val sseEmitter = mock(SseEmitter::class.java)

        val publisher = Publisher(subscriptions = ConcurrentHashMap(mapOf(key to sseEmitter)))
        publisher.publish(key, message)
        // verify that the method [send] was called once on a [sseEmitter] instance
        verify(sseEmitter).send(message)
    }

    @Test
    fun `subscribe should add new emitter to subscriptions`() {
        // setup
        val key = "user1"
        val subscriptions = ConcurrentHashMap<String, SseEmitter>()
        val publisher = Publisher(subscriptions = subscriptions)

        // subscribe and create emitter
        val sseEmitter = publisher.subscribe(key)
        // verify that emitter was created
        assertEquals(sseEmitter, subscriptions[key])
    }

    @Test
    fun `unsubscribe should complete emitter and remove from subscriptions`() {
        // setup
        val key = "user1"
        val subscriptions = ConcurrentHashMap<String, SseEmitter>()
        val publisher = Publisher(subscriptions = subscriptions)
        // create and place mock on subscriptions
        val sseEmitter = mock(SseEmitter::class.java)
        subscriptions[key] = sseEmitter

        // unsubscribe and close emitter
        val result = publisher.unsubscribe(key)
        // verify that emitter was closed
        verify(sseEmitter).complete()
        assertEquals(key, result)
        assertNull(subscriptions[key])
    }

    @Test
    fun `create a SseEmitter event`() {
        // setup
        val subscriptions = ConcurrentHashMap<String, SseEmitter>()
        val publisher = Publisher(subscriptions = subscriptions)
        val msg = "generic data"
        // create event
        val res = publisher.createEvent("id", "event", msg).build()

        assertEquals(3, res.size)
        assertEquals(true, res.any { event -> event.data == msg && event.mediaType == MediaType.APPLICATION_JSON })
    }
}