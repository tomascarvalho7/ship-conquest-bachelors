import 'package:flutter/material.dart';

/// Builds a screen template to be used in other lobby screens to avoid code repetition.
Widget buildScreenTemplateWidget(
        BuildContext context, List<Widget> childWidgets) =>
    Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.background,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child:
                  Stack(children: childWidgets)
                  )
                ]
            )
        )
    );
