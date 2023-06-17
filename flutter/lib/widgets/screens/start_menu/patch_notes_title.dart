import 'package:flutter/material.dart';

/// Builds the patch notes title.
Widget buildPatchNoteTitleWidget(BuildContext context) => SizedBox(
  width: double.infinity,
  child: Text('Patch Notes',
      style: Theme.of(context).textTheme.titleMedium),
);