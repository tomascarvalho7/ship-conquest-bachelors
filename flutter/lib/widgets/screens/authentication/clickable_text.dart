import 'package:flutter/material.dart';

/// Builds a generic clickable text Widget.
///
/// - [onTap] the function to execute on the text's tap action
/// - [text] the text to present
Widget buildClickableTextWidget(
        BuildContext context, Function() onTap, String text) =>
    GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .bodySmall
            ?.copyWith(
            fontSize: 15,
            color: Theme.of(context).colorScheme.secondary,
            decoration: TextDecoration.underline
        ),
      ),
    );
