import 'package:ship_conquest/domain/results/success_feedback.dart';
import 'package:ship_conquest/domain/results/error.dart';

class Result {
  final ErrorFeedback? error;
  final SuccessFeedback? success;

  Result({this.error, this.success});
}