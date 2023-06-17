import 'package:flutter/material.dart';

/// Builds the welcome text.
Widget buildWelcomeBackWidget(String? userName, BuildContext context) =>
    Container(
        padding: const EdgeInsets.only(bottom: 50),
        width: double.infinity,
        child: FittedBox(
          child: RichText(
              text: TextSpan(
                  style: Theme.of(context).textTheme.titleLarge,
                  children: [
                    const TextSpan(text: "Welcome back\n"),
                    TextSpan(
                      text: userName,
                      style: Theme.of(context).textTheme.titleMedium,
                    )
                  ])),
        )
    );