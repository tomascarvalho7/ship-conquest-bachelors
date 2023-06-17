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

  /// Updates the statistics of the player with [stats].
  void updateStatistics(PlayerStats stats) {
    statistics = stats;
    notifyListeners();
  }

  /// Checks if the player can make a transaction with their current currency.
  bool canMakeTransaction(int value) => statistics.currency >= value;

  /// Makes the transaction worth [value] and updates the player's statistics.
  void makeTransaction(int value) {
    statistics = PlayerStats(
        currency: statistics.currency + value,
        maxCurrency: statistics.maxCurrency
    );
    notifyListeners();
  }
}