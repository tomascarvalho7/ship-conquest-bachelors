enum Direction {
  up,
  left,
  down,
  right,
}

Direction getOrientationFromAngle(double ang) {
  final angle = ang + 45;
  if (angle > 0 && angle <= 90) return Direction.right;
  if (angle > 90 && angle <= 180) return Direction.down;
  if (angle > 180 && angle <= 270) return Direction.left;
  return Direction.up;
}