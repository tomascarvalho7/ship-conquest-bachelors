import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/error/error_type.dart';



/// Input Model class built from a Spring error default Json Response
/// Represents a back-end application error
class SpringErrorInputModel {
  final String timestamp;
  final int status;
  final String error;
  final String path;

  // Constructor to deserialize the input model from a JSON map.
  SpringErrorInputModel.fromJson(Map<String, dynamic> json):
        timestamp = json['timestamp'],
        status = json['status'],
        error = json['error'],
        path = json['path'];
}

// Convert back-end application error into a Client application feedback
extension ToFeedback on SpringErrorInputModel {
  /// Converts the [SpringErrorInputModel] to a [ErrorFeedback] object.
  toErrorFeedback() => ErrorFeedback(
      type: ErrorType.fatal,
      title: error,
      details: "An error happened, please restart the application."
  );
}