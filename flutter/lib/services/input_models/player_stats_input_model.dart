import 'package:ship_conquest/domain/stats/player_stats.dart';

class PlayerStatsInputModel {
  final int currency;
  final int maxCurrency;

  PlayerStatsInputModel.fromJson(Map<String, dynamic> json)
  :
      currency = json['currency'],
      maxCurrency = json['maxCurrency'];
}

extension ToDomain on PlayerStatsInputModel {
  PlayerStats toPlayerStats() =>
      PlayerStats(
          currency: currency,
          maxCurrency: maxCurrency
      );
}