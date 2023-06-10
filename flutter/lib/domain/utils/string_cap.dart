extension Cap on String {
  /// limit a string to a certain [max] number of characters
  String cap(int max) {
    if (length <= max) return this;

    return "${substring(0, max)}...";
  }
}