import 'package:flutter/material.dart';
import 'package:ship_conquest/widgets/screens/wave_loading_screen/wave_painter.dart';


/// Loading screen used in various occasions, presents a wave moving animation
/// in the center of the circle to bring some life to a loading widget.
///
/// The wave is rendered via a painter.
class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (BuildContext context, Widget? child) {
            return Transform.translate(
              offset: const Offset(0.0, 0.5),
              child: Container(
                width: 200.0,
                height: 200.0,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle,
                ),
                child: CustomPaint(
                  painter: WavePainter(
                    animationValue: _controller.value,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


