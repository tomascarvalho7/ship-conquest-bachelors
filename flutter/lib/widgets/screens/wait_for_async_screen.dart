import 'package:flutter/material.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/green_background.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/mountains_background.dart';

/// Simple loading widget for the menus.
///
/// Used to avoid code repetition.
class WaitForAsyncScreen extends StatelessWidget {
  final String mountainsPath;
  const WaitForAsyncScreen({super.key, required this.mountainsPath});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(child: CircularProgressIndicator()),
        buildGreenBackgroundWidget(context),
        buildMountainsBackgroundWidget(context, mountainsPath)
      ],
    );
  }
}