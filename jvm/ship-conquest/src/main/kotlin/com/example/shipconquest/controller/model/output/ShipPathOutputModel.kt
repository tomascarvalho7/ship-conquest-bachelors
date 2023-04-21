package com.example.shipconquest.controller.model.output

import com.example.shipconquest.domain.ship_navigation.CubicBezier

data class ShipPathOutputModel(val landmarks: List<CubicBezier>, val startTime: String, val duration: String)