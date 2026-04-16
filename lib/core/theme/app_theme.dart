import 'package:flutter/material.dart';

/// All theme data lives here. Only dark theme is defined per spec.
/// Add a light theme later by exposing [lightTheme] if needed.
class AppTheme {
  AppTheme._();

  static const Color _surface = Color(0xFF121218);
  static const Color _onSurface = Color(0xFFE8E8F0);
  static const Color _accent = Color(0xFFCDC000); // manul-eye yellow
  static const Color _muted = Color(0xFF4A4A5A);

  static ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: _surface,
        colorScheme: const ColorScheme.dark(
          surface: _surface,
          primary: _accent,
          onPrimary: Colors.black,
          onSurface: _onSurface,
          secondary: Color(0xFF546E7A),
        ),
        textTheme: const TextTheme(
          // "Manul #1,234" headline
          displayLarge: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
            color: _onSurface,
          ),
          // Sub-labels, mode badge
          bodyMedium: TextStyle(
            fontSize: 14,
            color: _muted,
            letterSpacing: 1.2,
          ),
          labelSmall: TextStyle(
            fontSize: 11,
            color: _muted,
            letterSpacing: 1.5,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: _accent,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            shape: const StadiumBorder(),
            textStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
            ),
          ),
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: _onSurface,
            backgroundColor: const Color(0xFF1E1E2C),
            padding: const EdgeInsets.all(16),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF1E1E2C),
            foregroundColor: _onSurface,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: const StadiumBorder(),
          ),
        ),
      );
}
