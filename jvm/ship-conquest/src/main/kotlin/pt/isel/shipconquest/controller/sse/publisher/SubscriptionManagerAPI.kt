package pt.isel.shipconquest.controller.sse.publisher

import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyEmitter
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter

interface SubscriptionManagerAPI {
    fun publish(key: String, message: Any)

    fun subscribe(key: String): SseEmitter

    fun unsubscribe(key: String): String

    fun createEvent(id: String, name: String, data: Any): MutableSet<ResponseBodyEmitter.DataWithMediaType>
}