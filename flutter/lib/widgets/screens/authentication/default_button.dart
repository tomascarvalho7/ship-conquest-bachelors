import 'package:flutter/material.dart';

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
