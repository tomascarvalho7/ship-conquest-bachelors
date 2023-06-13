import 'package:flutter/material.dart';

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
