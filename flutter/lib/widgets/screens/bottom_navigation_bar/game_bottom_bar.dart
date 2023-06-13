import 'package:flutter/material.dart';

class GameBottomBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const GameBottomBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  _GameBottomBarState createState() => _GameBottomBarState();
}

class _GameBottomBarState extends State<GameBottomBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<IconData> _icons;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _icons = [
      Icons.home,
      Icons.gamepad,
      Icons.arrow_back_ios_rounded
    ];
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 0.08,
            child: Container(
              alignment: Alignment.bottomCenter,
              constraints: const BoxConstraints(minHeight: 500),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Theme.of(context).colorScheme.background),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  _icons.length,
                      (index) => buildIconButton(
                    icon: _icons[index],
                    isActive: index == widget.currentIndex,
                    onPressed: () => widget.onTap(index),
                  ),
                ),
              ),
            )));
  }

  Widget buildIconButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onPressed,
  }) => GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: 64,
        width: 64,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ScaleTransition(
              scale: isActive
                  ? _animation
                  : Tween<double>(begin: 1.0, end: 0.7).animate(_controller),
              child: Icon(
                icon,
                color: isActive
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[400],
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
}
