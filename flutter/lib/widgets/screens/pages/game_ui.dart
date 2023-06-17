import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/widgets/screens/bottom_navigation_bar/game_bottom_bar.dart';
import 'package:ship_conquest/widgets/screens/game/game_screen.dart';
import 'package:ship_conquest/widgets/screens/leave_game/leave_game_screen.dart';

/// Builds the game's view with bottom bar navigation
///
/// PageView allows to show different screens with the same basis and also the same
/// navigation bar. It also transitions from one to another in a smooth way.
///
/// Controls the screens by indexes, which can be used for the bottom bar navigation.
class GameUI extends StatefulWidget {
  const GameUI({Key? key}) : super(key: key);

  @override
  State<GameUI> createState() => _GameUIState();
}

class _GameUIState extends State<GameUI> {
  int _currentIdx = 1;
  final PageController _pc = PageController(initialPage: 1);

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);

    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: GameBottomBar(
          currentIndex: _currentIdx,
          onTap: (index) {
            if (index != 1) {
              if (index == 2) {
                globalState.updateGameData(null);
              }
              setState(() {
                _currentIdx = index;
                _pc.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              });
            }
          },
        ),
      ),
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pc,
        children: const [
          LeaveGameScreen(),
          GameScreen(),
          LeaveGameScreen(),
        ],
        onPageChanged: (page) {
          setState(() {
            _currentIdx = page;
          });
        },
      ),
    );
  }
}
