import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/patch_notes/patch_note.dart';

/// Builds the patch note's text to be put inside the square.
Widget buildPatchNoteTextWidget(PatchNote note, BuildContext context) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      note.title,
      style: TextStyle(
        fontSize: 24,
        color: Theme.of(context).colorScheme.secondary,
      ),
    ),
    const SizedBox(height: 8),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: note.details.map((detail) {
        return Text(
          detail,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).colorScheme.secondary,
          ),
        );
      }).toList(),
    ),
  ],
);