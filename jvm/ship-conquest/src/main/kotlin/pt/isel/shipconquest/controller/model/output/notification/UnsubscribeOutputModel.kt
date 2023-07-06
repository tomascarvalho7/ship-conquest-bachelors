package com.example.shipconquest.controller.model.output.notification

data class UnsubscribedOutputModel(val key: String, val info: String)

fun subscriptionKeyToUnsubscribedOutputModel(key: String) =
    UnsubscribedOutputModel(
        key = key,
        info = "Unsubscribed. Stream with key = $key has been closed."
    )