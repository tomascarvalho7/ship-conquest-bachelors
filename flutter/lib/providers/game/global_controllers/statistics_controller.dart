import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';

///
/// Independent game related controller that holds [State] of
/// the player's statistics.
///
/// Mixin to the [ChangeNotifier] class, so widget's can
/// listen to changes to [State].
///
/// The [StatisticsController] stores and manages the player's
/// currency.
///
class StatisticsController with ChangeNotifier {
  late PlayerStats statistics;
  //constructor
  StatisticsController();

  void updateStatistics(PlayerStats stats) {
    statistics = stats;
    notifyListeners();
  }

  bool canMakeTransaction(int value) => statistics.currency >= value;

  void makeTransaction(int value) {
    statistics = PlayerStats(
        currency: statistics.currency + value,
        maxCurrency: statistics.maxCurrency
    );
    notifyListeners();
  }
}