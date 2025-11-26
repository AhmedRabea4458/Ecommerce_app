import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF293038);
  static const Color primaryComplement = Color(0xFFD6CFC7);

  static const Color secondary = Color(0xFF0A80ED);

  static const Color darkBackground = Color(0xFF121417);
  static const Color lightBackground = Color(0xFFF5F6FA);

  static const Color? darkTextPrimary = Colors.white;
  static const Color lightTextPrimary = Colors.black;

  static const Color darkTextSecondary = Color(0xFF9CABBA);
  static const Color lightTextSecondary = Color(0xFF4A4A4A);

  static const Color error = Colors.red;

  static Color background(bool isDarkMode) =>
      isDarkMode ? darkBackground : lightBackground;

  static Color? primaryTextColor(bool isDarkMode) =>
      isDarkMode ? darkTextPrimary : lightTextPrimary;

  static Color secondaryTextColor(bool isDarkMode) =>
      isDarkMode ? darkTextSecondary : lightTextSecondary;

  static Color iconColor(bool isDarkMode) =>
      isDarkMode ? Colors.white : Colors.black;

  static Color? primaryColor(bool isDarkMode) =>
      isDarkMode ? Colors.grey[900] : Colors.grey[300];

  static Color? category(bool isDarkMode) =>
      isDarkMode ? Colors.grey[800] : Colors.white;

}
