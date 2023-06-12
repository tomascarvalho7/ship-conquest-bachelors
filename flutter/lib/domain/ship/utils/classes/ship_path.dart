import 'dart:math';

import 'package:ship_conquest/domain/utils/get_time_percentage.dart';

import '../../../space/cubic_bezier.dart';
import '../../../space/position.dart';

/// Represents a ship Path
/// this data is global and reliable throughout the whole path
class ShipPath {
  // path landmarks/points
  final List<CubicBezier> landmarks;
  // path start time
  final DateTime startTime;
  // path travelling duration
  final Duration duration;
  // constructor
  ShipPath({required this.landmarks, required this.startTime, required this.duration});
  // optimizations
  late final endTime = startTime.add(duration);

  Position getPosition(double u) {
    final index = u.floor();
    if (index == landmarks.length) return landmarks.last.p3 * 1.0;

    final n = u % 1;
    return landmarks[index].get(n);
  }

  Position getPositionFromTime() {
    final percentage = getTimePercentage(startTime, endTime);
    return getPosition(percentage * landmarks.length);
  }

  double getAngle(double u) {
    final index = u.floor();
    if (index == landmarks.length) return landmarks.last.getAngleAtPoint(1.0);

    final n = u % 1;
    return landmarks[index].getAngleAtPoint(n);
  }

  double getAngleFromTime() {
    final percentage = getTimePercentage(startTime, endTime);
    return getAngle(percentage * landmarks.length);
  }

  double getStartFromTime() {
    final timeElapsed = DateTime.now().difference(startTime);
    final percentage = timeElapsed.inMilliseconds / duration.inMilliseconds;
    return min(landmarks.length.toDouble(), percentage * landmarks.length);
  }

  Duration getCurrentDuration() => endTime.difference(DateTime.now());

  bool hasReachedDestiny() => endTime.isBefore(DateTime.now());
}