import 'package:flutter/material.dart';
import 'package:ship_conquest/widgets/screens/onboarding/build_onboarding_screen.dart';

class ConquestOnBoardingScreen extends StatelessWidget {
  final void Function() onSkip;
  const ConquestOnBoardingScreen({super.key, required this.onSkip,});

  @override
  Widget build(BuildContext context) {
    return buildOnBoardingScreen(
        context,
            onSkip,
        "assets/images/thumbnail_conquest_ilustration.png",
        "Explore The World",
        "ihfpisgfsfowfojwjf+oj+gfwj+pgj+pojp+fgj+posghisdfhog");
  }
}
