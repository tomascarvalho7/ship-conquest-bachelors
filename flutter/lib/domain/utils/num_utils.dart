extension Range on int {
 /// Checks if an integer is between [from] and [to].
  bool isBetween(int from, int to) {
    return from <= this && this <= to;
  }
}