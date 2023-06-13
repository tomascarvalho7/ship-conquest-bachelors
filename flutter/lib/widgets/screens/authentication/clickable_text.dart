import 'package:flutter/material.dart';

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
            ?.copyWith(color: Theme.of(context).colorScheme.secondary),
      ),
    );
