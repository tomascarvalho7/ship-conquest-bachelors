import 'package:flutter/material.dart';
import 'package:ship_conquest/domain/results/error.dart';
import 'package:ship_conquest/domain/results/result.dart';
import 'package:ship_conquest/domain/results/success_feedback.dart';

class FeedbackController with ChangeNotifier {

  FeedbackController();

  Result _feedbackResult = Result();

  Result get result => _feedbackResult;

  void setSuccessful(SuccessFeedback success) {
    _feedbackResult = Result(success: success);
    notifyListeners();
  }

  void setError(ErrorFeedback error) {
    _feedbackResult = Result(error: error);
    notifyListeners();
  }

}