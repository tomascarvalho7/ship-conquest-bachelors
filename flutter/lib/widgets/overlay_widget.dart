import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'miscellaneous/notification/custom_notification.dart';

class OverlayWidget extends StatelessWidget {
  final Widget child;

  const OverlayWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Consumer<FeedbackController>(builder: (_, feedbackController, __) {
      if (feedbackController.hasFeedback) {
        final feedback = feedbackController.feedback;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (feedback != null) {
            showTopSnackBar(
                Overlay.of(context),
                CustomNotification(
                  title: feedback.isRight
                      ? feedback.right.title
                      : feedback.left.title,
                  message: feedback.isRight
                      ? feedback.right.details
                      : feedback.left.details,
                  success: feedback.isRight,
                ));
          }
          feedbackController.clearFeedback();
        });
      }
      return child;
    });
  }
}
