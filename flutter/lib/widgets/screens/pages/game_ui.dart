import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/widgets/screens/leave_game/leave_game_screen.dart';

import '../game/game.dart';
import '../game/game_screen.dart';
import '../game_loading/game_loading_screen.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIdx,
        onTap: (index) {
          if(index != 1) {
            if(index == 2) {
              print("asdsdasda");
              globalState.updateGameData(null);
            }
            setState(() {
              _currentIdx = index;
              _pc.animateToPage(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.gamepad),
            label: 'Game',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Leave Game',
          ),
        ],
      ),
    );
  }
}
