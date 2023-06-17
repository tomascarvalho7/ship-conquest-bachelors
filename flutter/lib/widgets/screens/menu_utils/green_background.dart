import 'package:flutter/material.dart';

/// Builds a default green background to show in the bottom of every menu screen.
Widget buildGreenBackgroundWidget(BuildContext context) => Align(
    alignment: Alignment.bottomCenter,
    child: FractionallySizedBox(
      heightFactor: 0.3,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    ));
