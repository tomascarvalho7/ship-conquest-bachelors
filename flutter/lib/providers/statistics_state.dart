import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/stats/player_stats.dart';

class StatisticsState with ChangeNotifier {
  PlayerStats statistics;
  //constructor
  StatisticsState({required this.statistics});

  void updateStatistics(PlayerStats stats) {
    statistics = stats;
  }
}