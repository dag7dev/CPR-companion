import 'package:flutter/material.dart';

class AppConfig {
  // static const bool debugMode = bool.fromEnvironment('flutter.debug');
  static const bool debugMode = true;
  static const int countdownSeconds = debugMode ? 3 : 10;
  static const int compressionsCount = debugMode ? 3 : 30;

  // color
  static const Color textInButtonsColor = Colors.white;
  static const Color textInTitlesColor = Colors.white;

  // Internal variables in the app
  static bool debugMetronome = false;
  static bool insufflazioni = false;
}
