import 'package:flutter/material.dart';

Widget buildMountainsBackgroundWidget(BuildContext context, String mountainFile) => Align(
  alignment: const Alignment(0, 0.5),
  child: SizedBox(
      child: Image.asset(
          mountainFile,
          fit: BoxFit.fill)),
);