import 'package:flutter/material.dart';

class FlexButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;
  const FlexButton({super.key, required this.onPressed, required this.child});

  @override
  Widget build(BuildContext context) =>
      GestureDetector(
        onTap: onPressed,
        child:
        Container(
          margin: const EdgeInsets.only(left: 10.0, bottom: 20.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
          ),
          child: child,
        )
      );
}