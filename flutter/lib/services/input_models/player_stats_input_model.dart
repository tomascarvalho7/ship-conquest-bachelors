import 'package:ship_conquest/domain/stats/player_stats.dart';

class PlayerStatsInputModel {
  final String tag;
  final String uid;
  final int currency;
  final int maxCurrency;

  PlayerStatsInputModel.fromJson(Map<String, dynamic> json)
  :
      tag = json['tag'],
      uid = json['uid'],
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