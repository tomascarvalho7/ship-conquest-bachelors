import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/error/error_type.dart';



/// Input Model Module class built from a Problem Json Response
/// Represents a back-end application error
class ProblemInputModel {
  final int status;
  final String title;
  final String details;

  ProblemInputModel.fromJson(Map<String, dynamic> json):
      status = json['status'],
      title = json['title'],
      details = json['details'];
}

/// Convert back-end application error
/// into Client application feedback
extension ToFeedback on ProblemInputModel {
  toErrorFeedback() => ErrorFeedback(
      type: status == 500 ? ErrorType.fatal : ErrorType.info,
      title: title,
      details: details
  );
}