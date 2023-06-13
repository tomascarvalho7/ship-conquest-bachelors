import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/patch_notes/patch_note.dart';

Widget buildPatchNoteTextWidget(PatchNote note) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
      note.title,
      style: const TextStyle(
        fontSize: 24,
        color: Colors.white,
      ),
    ),
    const SizedBox(height: 8),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: note.details.map((detail) {
        return Text(
          detail,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        );
      }).toList(),
    ),
  ],
);