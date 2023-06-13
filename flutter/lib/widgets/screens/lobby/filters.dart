enum DateFilter {
  newer,
  older,
}

enum FilterType {
  all,
  favorite,
  recent,
}

extension DateFilterToString on DateFilter {
  String get valueAsString {
    switch (this) {
      case DateFilter.newer:
        return "Newer";
      case DateFilter.older:
        return "Older";
    }
  }
}

extension DateFilterToOrder on DateFilter {
  String get toRequestOrder {
    switch (this) {
      case DateFilter.newer:
        return "descending";
      case DateFilter.older:
        return "ascending";
    }
  }
}