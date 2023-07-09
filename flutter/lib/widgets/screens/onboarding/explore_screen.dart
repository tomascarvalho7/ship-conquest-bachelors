import 'package:flutter/material.dart';
import 'package:ship_conquest/widgets/screens/onboarding/build_onboarding_screen.dart';

class ExploreOnBoardingScreen extends StatelessWidget {
  final void Function() onSkip;
  const ExploreOnBoardingScreen({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return buildOnBoardingScreen(
        context,
            onSkip,
        "assets/images/thumbnail_ilustration.png",
        "Explore The World",
        "Set sail on your ships and explore unique worlds with unknown land to be found!");
  }
}
