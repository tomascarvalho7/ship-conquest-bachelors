package com.example.shipconquest.domain.event

import java.time.Duration

data class FutureEvent(val event: Event, val duration: Duration)