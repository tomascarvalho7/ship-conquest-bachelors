import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/error/error_type.dart';

/// Input Model Module class built from a Problem Json Response
/// Represents a back-end application error.
class ProblemInputModel {
  final int status;
  final String title;
  final String details;

  // Constructor to deserialize the input model from a JSON map.
  ProblemInputModel.fromJson(this.status, Map<String, dynamic> json):
      title = json['title'],
      details = json['detail'];
}

// An extension on the [ProblemInputModel] class to convert it to an [ErrorFeedback] domain object.
extension ToFeedback on ProblemInputModel {
  /// Convert back-end application error in [ProblemInputModel]
  /// into Client application feedback of type [ErrorFeedback].
  toErrorFeedback() => ErrorFeedback(
      type: status == 500 ? ErrorType.fatal : ErrorType.info,
      title: title,
      details: details
  );
}