import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/error/error_type.dart';



/// Input Model Module class built from a Problem Json Response
/// Represents a back-end application error
class SpringErrorInputModel {
  final String timestamp;
  final int status;
  final String error;
  final String path;

  SpringErrorInputModel.fromJson(Map<String, dynamic> json):
        timestamp = json['timestamp'],
        status = json['status'],
        error = json['error'],
        path = json['path'];
}

/// Convert back-end application error
/// into Client application feedback
extension ToFeedback on SpringErrorInputModel {
  toErrorFeedback() => ErrorFeedback(
      type: status == 500 ? ErrorType.fatal : ErrorType.info,
      title: error,
      details: path + timestamp
  );
}