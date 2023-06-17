import 'package:ship_conquest/domain/stats/player_stats.dart';

/// Input model class representing input data for a player's statistics.
class PlayerStatsInputModel {
  final int currency;
  final int maxCurrency;

  // Constructor to deserialize the input model from a JSON map.
  PlayerStatsInputModel.fromJson(Map<String, dynamic> json) :
      currency = json['currency'],
      maxCurrency = json['maxCurrency'];
}

// An extension on the [PlayerStatsInputModel] class to convert it to an [PlayerStats] domain object.
extension ToDomain on PlayerStatsInputModel {
  /// Converts the [PlayerStatsInputModel] to a [PlayerStats] object.
  PlayerStats toPlayerStats() =>
      PlayerStats(
          currency: currency,
          maxCurrency: maxCurrency
      );
}