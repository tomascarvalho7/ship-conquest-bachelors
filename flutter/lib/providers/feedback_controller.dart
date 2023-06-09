import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/either/either.dart';
import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/success/success_feedback.dart';

class FeedbackController with ChangeNotifier {
  FeedbackController();

  Either<ErrorFeedback, SuccessFeedback>? _feedbackResult;

  bool get hasFeedback => _feedbackResult != null;
  Either<ErrorFeedback, SuccessFeedback>? get feedback => _feedbackResult;

  void setSuccessful(SuccessFeedback success) {
    _feedbackResult = Right(success);
    notifyListeners();
  }

  void setError(ErrorFeedback error) {
    _feedbackResult = Left(error);
    notifyListeners();
  }

  void clearFeedback() {
    _feedbackResult = null;
  }
}