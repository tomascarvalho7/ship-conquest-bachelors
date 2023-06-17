/// Identifies the possible sorting filters
enum DateFilter {
  newer,
  older,
}

/// Identifies the possible types of libbies to search for
enum FilterType {
  all,
  favorite,
  recent,
}

extension DateFilterToString on DateFilter {
  /// Extension on [DateFilter] to present the text to the user
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
  /// Extension on [DateFilter] to prepare the filter for a API request
  String get toRequestOrder {
    switch (this) {
      case DateFilter.newer:
        return "descending";
      case DateFilter.older:
        return "ascending";
    }
  }
}