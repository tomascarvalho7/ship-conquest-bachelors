import 'package:flutter/material.dart';
import 'package:ship_conquest/widgets/miscellaneous/notification/custom_notification.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NotificationController {
    void createGreenNotification(String title, String description) {
      showTopSnackBar(OverlayState(), CustomNotification(
        title: title,
        message: description,
        success: true,
      ));
    }

    void createRedNotification(String title, String description) {
      showTopSnackBar(OverlayState(), CustomNotification(
        title: title,
        message: description,
        success: false,
      ));
    }
}
