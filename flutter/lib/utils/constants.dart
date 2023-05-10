import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/color/color_gradient.dart';
import 'package:ship_conquest/domain/utils/factor.dart';
import 'package:ship_conquest/providers/game/event_handlers/game_event.dart';

import '../domain/color/color_mark.dart';
import '../domain/color/color_ramp.dart';
import '../providers/game/event_handlers/minimap_event.dart';

const tileSize = 32.0;
const tileSizeWidthHalf = tileSize / 2;
const tileSizeHeightHalf = tileSize / 4;
const chunkSize = 10;
const waterColor = Color.fromRGBO(60, 151, 207, 1.0);
// scale
const globalScale = 1.0;
const minimapSize = 900.0;
// eventHandlers
const gameEvent = GameEvent();
const minimapEvent = MinimapEvent();
// color ramp & gradient
const ColorRamp colorRamp = ColorRamp(colors: [
  ColorMark(factor: Factor(value: 0.0), color: waterColor),
  ColorMark(factor: Factor(value: 0.01), color: Color.fromRGBO(196, 190, 175, 1.0)),
  ColorMark(factor: Factor(value: 0.1), color: Color.fromRGBO(211, 168, 119, 1.0)),
  ColorMark(factor: Factor(value: 0.15), color: Color.fromRGBO(116, 153, 72, 1.0)),
  ColorMark(factor: Factor(value: 0.3), color: Color.fromRGBO(77, 130, 40, 1.0)),
  ColorMark(factor: Factor(value: 0.7), color: Color.fromRGBO(177, 211, 114, 1.0)),
  ColorMark(factor: Factor(value: 0.71), color: Color.fromRGBO(170, 145, 107, 1.0)),
  ColorMark(factor: Factor(value: 0.85), color: Color.fromRGBO(157, 117, 64, 1.0)),
  ColorMark(factor: Factor(value: 1.0), color: Color.fromRGBO(255, 255, 255, 1.0)),
]);

ColorGradient colorGradient = ColorGradient(colorRamp: colorRamp, step: const Factor(value: 0.01));