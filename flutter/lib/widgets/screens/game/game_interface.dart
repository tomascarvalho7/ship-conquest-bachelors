import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ship_conquest/widgets/screens/game/utils/currency_view.dart';
import 'package:ship_conquest/widgets/screens/game/utils/game_details_slider.dart';
import 'package:ship_conquest/widgets/screens/minimap/minimap_icon.dart';


/// Builds the game interface by joining the minimap icon, and currency,
/// the game, and the slider.
class GameInterface extends StatelessWidget {
  final Widget gameView;
  const GameInterface({super.key, required this.gameView});

  @override
  Widget build(BuildContext context) =>
      Stack(
        children: [
          gameView,
          topBar(context),
          const GameDetailsSlider()
        ]
      );

  /// Builds the top game section
  Widget topBar(BuildContext context) =>
      Align(
        alignment: const Alignment(0.0, -0.8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              MinimapIcon(
                  onClick: () {
                    context.go('/minimap'); // go to minimap screen
                  }
              ),
              const SizedBox(width: 150),
              const CurrencyView()
            ]
        )
      );
}