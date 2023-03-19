import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/widgets/canvas/test_painter.dart';

class PainterPreview extends StatefulWidget {
  const PainterPreview({super.key});

  @override
  State<StatefulWidget> createState() => PainterPreviewState();
}

class PainterPreviewState extends State<PainterPreview> with TickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this
  )
    ..repeat();
  late final animation = IntTween(begin: 0, end: 100).animate(controller);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
        painter: TestPainter(animation),
        child: const SizedBox.expand()
    );
  }
}