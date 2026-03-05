import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get largeFontTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 24.0, color: Colors.black87),
        bodyMedium: TextStyle(fontSize: 20.0, color: Colors.black87),
        titleLarge: TextStyle(fontSize: 28.0, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          textStyle: const TextStyle(fontSize: 20.0),
        ),
      ),
    );
  }
}