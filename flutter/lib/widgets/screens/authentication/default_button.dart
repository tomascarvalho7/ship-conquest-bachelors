import 'package:flutter/material.dart';

/// Builds a generic square button.
///
/// - [onTap] the function to execute on the button's tap action
/// - [message] the text to present
Widget buildSignInButtonWidget(
        BuildContext context, Function() onTap, String message) =>
    ElevatedButton(
      onPressed: onTap,
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
            minimumSize: MaterialStateProperty.all(const Size(231, 68)),
          ),
      child: Text(
        message,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
