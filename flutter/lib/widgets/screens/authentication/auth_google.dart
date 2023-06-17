import 'package:flutter/material.dart';

/// Widget holding the top part of the authentication screen
/// Builds the text and Google image logo
Widget buildAuthWithGoogleWidget(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(39, 104, 39, 154),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Text('Authenticate with ',
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.titleMedium),
        ),
        Container(
            margin: const EdgeInsets.fromLTRB(4.5, 0, 0, 0),
            width: 162,
            height: 55,
            child: Image.asset('assets/images/google-full-logo.png',
                fit: BoxFit.fill)),
      ],
    ));
