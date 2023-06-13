import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:ship_conquest/providers/sound_controller.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'miscellaneous/notification/custom_notification.dart';

class OverlayWidget extends StatelessWidget {
  final Widget child;

  const OverlayWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) =>
    Consumer2<FeedbackController, SoundController>(
        builder: (_, feedbackController, soundController, __) {
          if (feedbackController.hasFeedback) {
            WidgetsBinding.instance.addPostFrameCallback((_) =>
              displayNotification(context, feedbackController, soundController)
            );
          }
          return child;
        }
    );

  void displayNotification(
        BuildContext context,
        FeedbackController feedbackController,
        SoundController soundController
    ) {
      final feedback = feedbackController.feedback; // read feedback
      if (feedback == null) return; // do nothing if null

      soundController.playNotificationSound(); // play notification sound
      showTopSnackBar( // draw snack bar on top of screen
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
    feedbackController.clearFeedback(); // clear feedback
  }
}
