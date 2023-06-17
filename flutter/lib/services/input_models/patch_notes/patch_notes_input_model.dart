import 'package:ship_conquest/domain/patch_notes/patch_notes.dart';
import 'package:ship_conquest/services/input_models/patch_notes/patch_note_input_model.dart';

/// Input model class representing input data for a list of patch notes.
class PatchNotesInputModel {
  final List<PatchNoteInputModel> list;

  // Constructor to deserialize the input model from a JSON map.
  PatchNotesInputModel.fromJson(Map<String, dynamic> json) :
        list = List<dynamic>.from(json['list'])
            .map((e) => PatchNoteInputModel.fromJson(e))
            .toList();
}

// An extension on the [PatchNotesInputModel] class to convert it to an [PatchNotes] domain object.
extension ToDomain on PatchNotesInputModel {
  /// Converts the [PatchNotesInputModel] to a [PatchNotes] object.
  PatchNotes toPatchNotes() =>
      PatchNotes(notes: list.map((note) => note.toPatchNote()).toList());
}