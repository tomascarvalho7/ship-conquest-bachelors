extension Cap on String {
  /// Limit a string to a certain [max] number of characters.
  String cap(int max) {
    if (length <= max) return this;

    return "${substring(0, max)}...";
  }
}