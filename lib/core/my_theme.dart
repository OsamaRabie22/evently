import 'package:flutter/material.dart';

class MyThemeData {
  static ThemeData lightTheme = ThemeData(
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      showSelectedLabels: true,
      showUnselectedLabels: true,
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF0E3A99),
      // Main color
      onPrimary: Color(0xFFFFFFFF),
      // Text on primary color
      secondary: Color(0xFF686868),
      // Secondary text
      onSecondary: Color(0xFFB9B9B9),
      // Text on secondary color
      error: Color(0xFFFF3232),
      // Red (error)
      onError: Color(0xFFFFFFFF),
      // Text on error color
      surface: Color(0xFFF4F7FF),
      // Background
      onSurface: Color(0xFF1C1C1C),
      inversePrimary: Color(0xFFB9B9B9),
      // Main text
      surfaceVariant: Color(0xFFF0F0F0),
      // Stroke color
      onTertiary: Color(0xFF0E3A99),
      inverseSurface: Color(0xFF0E3A99),
    ),
    scaffoldBackgroundColor: Color(0xFFF4F7FF),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF457AED),
      // Main color
      onPrimary: Color(0xFF001440),
      // Text on primary color
      secondary: Color(0xFFD6D6D6),
      // Secondary text
      onSecondary: Color(0xFFB9B9B9),
      // Text on secondary color
      error: Color(0xFFFF3232),
      // Red (error)
      onError: Color(0xFFFFFFFF),
      // Text on error color
      surface: Color(0xFF000F30),
      // Background
      onSurface: Color(0xFFFFFFFF),
      inversePrimary: Color(0xFFFFFFFF),
      // Main text
      surfaceVariant: Color(0xFF002D8F),
      // Stroke color
      onTertiary: Color(0xFFFFFFFF),
      inverseSurface: Color(0xFF000F30),
    ),
    scaffoldBackgroundColor: Color(0xFF000F30),
  );
}
