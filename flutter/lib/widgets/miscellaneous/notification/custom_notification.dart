import 'package:flutter/material.dart';

/// Custom notification widget, used both for success and error feedbacks
///
/// - [title] the notification's title.
/// - [message] the notification's main message.
/// - [success] indicates if the notification should indicate success or error
class CustomNotification extends StatelessWidget {
  final String title;
  final String message;
  final bool success;

  const CustomNotification({
    Key? key,
    required this.title,
    required this.message,
    required this.success,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: success
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.error,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
