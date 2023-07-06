import 'package:flutter/material.dart';
import 'package:ship_conquest/widgets/screens/onboarding/build_onboarding_screen.dart';

class FightOnBoardingScreen extends StatelessWidget {
  final void Function() onSkip;
  const FightOnBoardingScreen({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return buildOnBoardingScreen(
        context,
            onSkip,
        "assets/images/thumbnail_fight_ilustration.png",
        "Fight Other Players",
        "ihfpisgfsfowfojwjf+oj+gfwj+pgj+pojp+fgj+posghisdfhog");
  }
}
