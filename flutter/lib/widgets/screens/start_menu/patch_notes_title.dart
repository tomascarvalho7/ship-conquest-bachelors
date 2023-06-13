import 'package:flutter/material.dart';

Widget buildPatchNoteTitleWidget(BuildContext context) => SizedBox(
  width: double.infinity,
  child: Text('Patch Notes',
      style: Theme.of(context).textTheme.titleMedium),
);