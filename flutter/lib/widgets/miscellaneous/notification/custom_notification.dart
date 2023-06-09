import 'package:flutter/material.dart';

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
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox.expand(
          child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.1,
              child: Container(
                decoration: BoxDecoration(
                  color: success ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.error,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Text(
                        message,
                        style: Theme.of(context).textTheme.bodySmall
                    ),
                  ],
                ),
              )
          ),
        )
      ],
    );
  }
}