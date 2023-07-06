import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/user_storage.dart';
import 'package:ship_conquest/widgets/screens/onboarding/conquest_screen.dart';
import 'package:ship_conquest/widgets/screens/onboarding/explore_screen.dart';
import 'package:ship_conquest/widgets/screens/onboarding/fight_screen.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userStorage = context.read<UserStorage>();
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      body: Stack (
        children: [
          Align(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              children: [
                ExploreOnBoardingScreen(onSkip: () {
                  final pageIdx = _currentPage + 1;
                  setState(() {
                    _currentPage = pageIdx;
                  });
                  _pageController.animateToPage(
                    pageIdx,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }),
                ConquestOnBoardingScreen(onSkip: () {
                  final pageIdx = _currentPage + 1;
                  setState(() {
                    _currentPage = pageIdx;
                  });
                  _pageController.animateToPage(
                    pageIdx,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                }),
                FightOnBoardingScreen(onSkip: () {
                  userStorage.setFirstTime();
                  context.go("/signIn");
                })
              ],
            ),
          ),
          Align(
            alignment: const Alignment(0.0, 0.1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  width: 20.0,
                  height: 20.0,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
