import 'package:flutter/material.dart';

Widget buildOnBoardingScreen(
    BuildContext context,
    void Function() onSkip,
    String imagePath,
    String title,
    String description,
    ) =>
    Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Stack(
                  children: [
                    Align(
                      alignment: const Alignment(0, -0.7),
                        child: Image.asset(imagePath),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.25),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.secondary
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 50),
                        child: Text(
                          description,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary
                          )
                        ),
                      ),
                    ),
                    Align(
                      alignment: const Alignment(0, 0.8),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: IconButton(
                          onPressed: onSkip,
                          icon: const Icon(Icons.arrow_forward, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );