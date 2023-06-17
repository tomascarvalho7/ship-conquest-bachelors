
import 'package:ship_conquest/domain/patch_notes/patch_note.dart';

/// Input model class representing input data for a game patch note.
class PatchNoteInputModel {
  final String title;
  final List<String> details;

  // Constructor to deserialize the input model from a JSON map.
  PatchNoteInputModel.fromJson(Map<String, dynamic> json) :
        title = json['title'],
        details = List<String>.from(json['notes']);
}

// An extension on the [PatchNoteInputModel] class to convert it to a [PatchNote] domain object.
extension ToDomain on PatchNoteInputModel {
  /// Converts the [PatchNoteInputModel] to a [PatchNote] object.
  PatchNote toPatchNote() =>
      PatchNote(
          title: title,
          details: details
      );
}