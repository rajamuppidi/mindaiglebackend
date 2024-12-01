import 'package:flutter/material.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.blue,
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontFamily: 'PlusJakartaSans'),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black, fontFamily: 'PlusJakartaSans'),
      bodyMedium: TextStyle(color: Colors.black, fontFamily: 'PlusJakartaSans'),
      headlineMedium:
          TextStyle(color: Colors.black, fontFamily: 'PlusJakartaSans'),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFFF1F4F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.blue,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      error: Colors.red,
    ),
  );

  static final darkTheme = ThemeData(
    primaryColor: const Color.fromRGBO(2, 47, 85, 1),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromRGBO(2, 47, 85, 1),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontFamily: 'PlusJakartaSans'),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans'),
      bodyMedium: TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans'),
      headlineMedium:
          TextStyle(color: Colors.white, fontFamily: 'PlusJakartaSans'),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromRGBO(2, 47, 85, 1),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: const Color.fromRGBO(2, 47, 85, 1),
      ),
    ),
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue,
      secondary: Colors.blueAccent,
      error: Colors.red,
    ),
  );
}
