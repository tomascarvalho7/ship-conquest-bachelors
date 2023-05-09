import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/global_state.dart';
import 'package:ship_conquest/widgets/screens/bottom_navigation_bar/home_bottom_bar.dart';
import 'package:ship_conquest/widgets/screens/lobby/lobby.dart';
import 'package:ship_conquest/widgets/screens/profile/user_profile.dart';
import 'package:ship_conquest/widgets/screens/start_menu/start_menu.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIdx = 1;
  final PageController _pc = PageController(initialPage: 1);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);

    return Scaffold(
      //key options to make navbar appear in front and floating
      extendBody: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar:
      Container(
        padding: const EdgeInsets.only(bottom: 30),
        child: HomeBottomBar(
          currentIndex: _currentIdx,
          onTap: (index) {
            // take the focus out of the keyboard
            FocusManager.instance.primaryFocus?.unfocus();
            if(index == 2 && globalState.gameData != null){
              context.go("/game-home");
            }
            setState(() {
              _pc.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.ease,
              );
            });
          },
        ),
      )
      ,
      body:
          PageView(
            controller: _pc,
            children: const [
              ProfileScreen(),
              StartMenuScreen(),
              LobbyScreen()
            ],
            onPageChanged: (page) {
              if(page == 2 && globalState.gameData != null){
                context.go("/game-home");
              }
              setState(() {
                _currentIdx = page;
              });
            },
          ),
    );
  }
}
