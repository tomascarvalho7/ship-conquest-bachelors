import 'package:flutter/cupertino.dart';

class FlexButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  const FlexButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) =>
      GestureDetector(
        onTap: onPressed,
        child: child
      );
}