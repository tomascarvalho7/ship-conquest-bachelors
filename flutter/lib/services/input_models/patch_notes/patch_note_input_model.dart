import '../../../domain/patch_notes/patch_note.dart';

class PatchNoteInputModel {
  final String title;
  final List<String> details;

  PatchNoteInputModel.fromJson(Map<String, dynamic> json)
      :
        title = json['title'],
        details = List<String>.from(json['notes']);
}

extension ToDomain on PatchNoteInputModel {
  PatchNote toPatchNote() =>
      PatchNote(
          title: title,
          details: details
      );
}