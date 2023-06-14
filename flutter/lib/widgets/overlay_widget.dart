import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ship_conquest/providers/feedback_controller.dart';
import 'package:ship_conquest/providers/sound_controller.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'miscellaneous/notification/custom_notification.dart';

class OverlayWidget extends StatefulWidget {
  final Widget child;

  const OverlayWidget({Key? key, required this.child}) : super(key: key);

  @override
  OverlayWidgetState createState() => OverlayWidgetState();
}

class OverlayWidgetState extends State<OverlayWidget> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final feedbackController = context.read<FeedbackController>();
    final soundController = context.read<SoundController>();
    if (state == AppLifecycleState.paused) {
      soundController.pauseAudio();
    }
    if (state == AppLifecycleState.resumed) {
      soundController.resumeAudio();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Consumer2<FeedbackController, SoundController>(
          builder: (_, feedbackController, soundController, __)  {
            if (feedbackController.hasFeedback) {
              WidgetsBinding.instance.addPostFrameCallback((_) =>
                  displayNotification(context, feedbackController, soundController));
            }
            return widget.child;
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
    showTopSnackBar(
      Overlay.of(context),
      CustomNotification(
        title: feedback.isRight ? feedback.right.title : feedback.left.title,
        message: feedback.isRight ? feedback.right.details : feedback.left.details,
        success: feedback.isRight,
      ),
    );
    feedbackController.clearFeedback(); // clear feedback
  }
}