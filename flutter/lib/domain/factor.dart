class Factor {
  late final double value;

  Factor(double fraction) {
    value = fraction % 1.01;
  }
}