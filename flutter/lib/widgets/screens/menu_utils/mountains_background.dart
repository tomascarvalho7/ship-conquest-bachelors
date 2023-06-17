import 'package:flutter/material.dart';

/// Builds the mountains background for each menu, by accepting the image's source.
///
/// - [mountainFile] the source of the file to be presented.
Widget buildMountainsBackgroundWidget(BuildContext context, String mountainFile) => Align(
  alignment: const Alignment(0, 0.5),
  child: SizedBox(
      child: Image.asset(
          mountainFile,
          fit: BoxFit.fill)),
);
