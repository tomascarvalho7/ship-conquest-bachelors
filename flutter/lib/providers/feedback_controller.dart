import 'package:flutter/cupertino.dart';
import 'package:ship_conquest/domain/either/either.dart';
import 'package:ship_conquest/domain/feedback/error/error_feedback.dart';
import 'package:ship_conquest/domain/feedback/success_feedback.dart';

class FeedbackController with ChangeNotifier {
  FeedbackController();

  late Either<ErrorFeedback, SuccessFeedback> _feedbackResult;

  Either<ErrorFeedback, SuccessFeedback> get feedback => _feedbackResult;

  void setSuccessful(SuccessFeedback success) {
    _feedbackResult = Right(success);
    notifyListeners();
  }

  void setError(ErrorFeedback error) {
    _feedbackResult = Left(error);
    notifyListeners();
  }
}