import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';

class StatisticsController with ChangeNotifier {
  late PlayerStats statistics;
  //constructor
  StatisticsController();

  void updateStatistics(PlayerStats stats) {
    statistics = stats;
  }
}