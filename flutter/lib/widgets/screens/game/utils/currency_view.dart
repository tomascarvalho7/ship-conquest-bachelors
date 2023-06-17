import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/game/global_controllers/statistics_controller.dart';

/// A widget representing a view for displaying currency statistics.
class CurrencyView extends StatelessWidget {
  // constructor
  const CurrencyView({super.key});

  @override
  Widget build(BuildContext context) =>
      Consumer<StatisticsController>(
        builder: (_, state, __) =>
            Container(
              width: 120,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[300],
              ),
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: state.statistics.currency / state.statistics.maxCurrency,
                    child: Container(
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: const Color.fromRGBO(56, 162, 110, 1.0)
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                        '${state.statistics.currency} / ${state.statistics.maxCurrency}',
                        style: const TextStyle(
                          fontSize: 14,
                          decoration: TextDecoration.none,
                          color: Colors.black54
                        ),
                    ),
                  ),
                ],
              ),
            )
      );
}