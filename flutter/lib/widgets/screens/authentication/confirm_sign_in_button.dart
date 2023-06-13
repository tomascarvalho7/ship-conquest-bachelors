import 'package:flutter/material.dart';

Widget buildConfirmSignInWidget(
        BuildContext context, Function() onTap, String text) =>
    ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        minimumSize: const Size(118, 37),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
    );
