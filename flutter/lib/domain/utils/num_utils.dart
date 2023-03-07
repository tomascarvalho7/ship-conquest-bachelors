extension Range on int {
  bool isBetween(int from, int to) {
    return from <= this && this <= to;
  }
}