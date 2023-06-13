import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import 'package:ship_conquest/services/input_models/patch_notes/patch_note_input_model.dart';

class PatchNotesInputModel {
  final List<PatchNoteInputModel> list;

  PatchNotesInputModel.fromJson(Map<String, dynamic> json) :
        list = List<dynamic>.from(json['list'])
            .map((e) => PatchNoteInputModel.fromJson(e))
            .toList();
}

extension ToDomain on PatchNotesInputModel {
  PatchNotes toPatchNotes() =>
      PatchNotes(notes: list.map((note) => note.toPatchNote()).toList());
}