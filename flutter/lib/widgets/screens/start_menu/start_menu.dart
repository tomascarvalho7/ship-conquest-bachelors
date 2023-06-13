import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/green_background.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/mountains_background.dart';
import 'package:ship_conquest/widgets/screens/menu_utils/screen_template.dart';
import 'package:ship_conquest/widgets/screens/start_menu/patch_note_square.dart';
import 'package:ship_conquest/widgets/screens/start_menu/start_menu_top_texts.dart';
import 'package:ship_conquest/widgets/screens/wait_for_async_screen.dart';
import '../../../providers/game/event_handlers/general_event.dart';

class StartMenuScreen extends StatefulWidget {
  const StartMenuScreen({Key? key}) : super(key: key);

  @override
  _StartMenuScreenState createState() => _StartMenuScreenState();
}

class _StartMenuScreenState extends State<StartMenuScreen> {
  String? userName;
  PatchNotes patchNotes = PatchNotes(notes: []);

  @override
  void initState() {
    super.initState();
    _getUserName();
    _getPatchNotes();
  }

  Future<void> _getUserName() async {
    GeneralEvent.getPersonalInfo(
        context,
        (userInfo) =>
            setState(() => userName = userInfo.name.split(' ').first));
  }

  Future<void> _getPatchNotes() async {
    GeneralEvent.getPatchNotes(
        context, (notes) => setState(() => patchNotes = notes));
  }

  @override
  Widget build(BuildContext context) {
    return buildScreenTemplateWidget(context, [
      if (userName != null) ...[
        buildStartMenuTopTextsWidget(userName, context),
        buildPatchNoteSquareWidget(context, patchNotes.notes),
        buildGreenBackgroundWidget(context),
        buildMountainsBackgroundWidget(
            context, 'assets/images/menu_mountains.png'),
      ] else ...[
        const WaitForAsyncScreen(
          mountainsPath: 'assets/images/menu_mountains.png',
        )
      ]
    ]);
  }
}
