package pt.isel.shipconquest.controller.sse.publisher

import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyEmitter
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter

/**
 * Publisher API mock for testing
 * the [data] variable stores the for every method,
 * the number of times it was called, like so:
 * Key          Value
 * "Method" =>  Nr of invocations
 */
class SubscriptionManagerMock(val data: MutableMap<String, Int>): SubscriptionManagerAPI {
    override fun publish(key: String, message: Any) = incrementMethod("publish")

    override fun subscribe(key: String): SseEmitter {
        incrementMethod("subscribe")
        return SseEmitter()
    }

    override fun unsubscribe(key: String): String {
        incrementMethod("unsubscribe")
        return key
    }

    override fun createEvent(id: String, name: String, data: Any): MutableSet<ResponseBodyEmitter.DataWithMediaType> {
        incrementMethod("createEvent")
        return SseEmitter
            .event()
            .id("fake")
            .data("generic Message")
            .build()
    }

    private fun incrementMethod(method: String) {
        val nrOfInvocations = data[method]
        data[method] = nrOfInvocations?.plus(1) ?: 1
    }
}