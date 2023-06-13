import 'package:flutter/material.dart';
import 'package:ship_conquest/widgets/screens/start_menu/patch_notes_title.dart';
import 'package:ship_conquest/widgets/screens/start_menu/welcome_back_group.dart';

Widget buildStartMenuTopTextsWidget(String? userName, BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(39, 60, 75, 9),
    width: double.infinity,
    child: Column(
      children: [
        buildWelcomeBackWidget(userName, context),
        buildPatchNoteTitleWidget(context)
      ],
    ));