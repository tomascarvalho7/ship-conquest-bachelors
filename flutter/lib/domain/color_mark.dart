import 'dart:ui';
import 'package:ship_conquest/domain/factor.dart';

class ColorMark {
  // value between 0 and 1
  late final Factor factor;
  final Color color;

  ColorMark({required this.factor, required this.color});
}