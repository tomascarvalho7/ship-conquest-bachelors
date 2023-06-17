import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/utils/factor.dart';

class ColorMark {
  // value between 0 and 1
  final Factor factor;
  final Color color;

  const ColorMark({required this.factor, required this.color});
}