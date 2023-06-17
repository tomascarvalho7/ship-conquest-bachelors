import 'package:ship_conquest/domain/feedback/error/error_type.dart';

/// Class representing the feedback of an error defined by its [type], [title] and [details].
class ErrorFeedback {
  final ErrorType type;
  final String title;
  final String details;

  const ErrorFeedback({required this.type, required this.title, required this.details});
}