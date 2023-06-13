import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/patch_notes/patch_note.dart';
import 'package:ship_conquest/widgets/screens/start_menu/patch_note_text.dart';

Widget buildPatchNoteSquareWidget(
    BuildContext context, List<PatchNote> patchNotes) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      final double height = constraints.maxHeight * 0.25;
      final double width = constraints.maxWidth * 0.9;

      return Align(
        alignment: const Alignment(0, -0.15),
        child: SizedBox(
          width: width,
          height: height,
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 10, 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: const LinearGradient(
                begin: Alignment(-0, 1),
                end: Alignment(-0, -1),
                colors: [
                  Color.fromRGBO(230, 96, 87, 1),
                  Color.fromRGBO(231, 114, 113, 0.2)
                ],
              ),
              border: Border.all(
                width: 2.0,
                style: BorderStyle.solid,
                color: const Color.fromRGBO(0, 0, 0, 0.3),
              ),
            ),
            child: patchNotes.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Align(
                    alignment: Alignment.bottomLeft,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: patchNotes.length,
                      itemBuilder: (context, index) => buildPatchNoteTextWidget(
                          patchNotes[patchNotes.length - index - 1]),
                    ),
                  ),
          ),
        ),
      );
    },
  );
}
