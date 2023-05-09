import 'package:flutter/material.dart';

ThemeData shipConquestDarkTheme = ThemeData(
    colorScheme: const ColorScheme(
      primary: Color(0xff30a574),
      secondary: Colors.white,
      surface: Colors.white,
      background: Color.fromRGBO(70, 70, 70, 1.0),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    fontFamily: 'DMSans',
    textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 40.0, color: Colors.white),
        titleMedium: TextStyle(fontSize: 34.0, color: Colors.white),
        bodyLarge: TextStyle(fontSize: 24.0, color: Colors.black),
        bodyMedium: TextStyle(fontSize: 18.0, color: Color.fromRGBO(70, 70, 70, 1.0)),
        bodySmall: TextStyle(color: Colors.black)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    )));

ThemeData shipConquestLightTheme = ThemeData(
    colorScheme: const ColorScheme(
      primary: Color(0xff30a574),
      secondary: Color.fromRGBO(70, 70, 70, 1.0),
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black,
      onBackground: Colors.black,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    fontFamily: 'DMSans',
    textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 40.0, color: Colors.black),
        titleMedium: TextStyle(fontSize: 34.0, color: Colors.black),
      bodyLarge: TextStyle(fontSize: 24.0, color: Colors.black),
      bodyMedium: TextStyle(fontSize: 18.0, color: Colors.white),
        bodySmall: TextStyle(color: Colors.white),),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
    )));
