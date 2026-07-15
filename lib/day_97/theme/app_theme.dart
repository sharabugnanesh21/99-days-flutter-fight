// ============================================================================
// APP THEME — a clean, Apple-inspired look.
//
// The recipe (borrowed from Apple's product/marketing pages):
//   - ONE accent color (system blue), used sparingly.
//   - Soft off-white / near-black backgrounds, not pure white/black.
//   - Generous whitespace + large rounded corners (14–20px).
//   - Bold, tight-tracked headlines; calm, readable body text.
//   - Subtle elevation instead of hard borders.
//
// Both a light and a dark theme are defined; MaterialApp below switches
// between them automatically based on the device setting (ThemeMode.system).
// ============================================================================

import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  // Apple's "system blue" — the one accent color used everywhere.
  static const _blueLight = Color(0xFF007AFF);
  static const _blueDark = Color(0xFF0A84FF);

  static ThemeData get light => _build(
    brightness: Brightness.light,
    accent: _blueLight,
    scaffoldBg: const Color(0xFFF5F5F7), // Apple's off-white page background
    surface: Colors.white,
    ink: const Color(0xFF1D1D1F), // near-black label color
    inkSoft: const Color(0xFF6E6E73), // secondary label gray
  );

  static ThemeData get dark => _build(
    brightness: Brightness.dark,
    accent: _blueDark,
    scaffoldBg: const Color(0xFF000000), // true black, like iOS dark mode
    surface: const Color(0xFF1C1C1E), // Apple's dark "elevated surface" gray
    ink: const Color(0xFFF5F5F7),
    inkSoft: const Color(0xFF98989D),
  );

  static ThemeData _build({
    required Brightness brightness,
    required Color accent,
    required Color scaffoldBg,
    required Color surface,
    required Color ink,
    required Color inkSoft,
  }) {
    final scheme = ColorScheme.fromSeed(
      seedColor: accent,
      brightness: brightness,
      primary: accent,
      surface: surface,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      scaffoldBackgroundColor: scaffoldBg,

      // Large, bold, tight-tracked headlines; calm body text — the SF Pro feel.
      textTheme: TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: ink,
        ),
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
          color: ink,
        ),
        bodyMedium: TextStyle(fontSize: 15, height: 1.4, color: ink),
        bodySmall: TextStyle(fontSize: 13, height: 1.35, color: inkSoft),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
          color: inkSoft,
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBg,
        foregroundColor: ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: ink,
        ),
      ),

      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        contentTextStyle: TextStyle(color: scaffoldBg),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),

      dividerTheme: DividerThemeData(color: inkSoft.withValues(alpha: 0.18), thickness: 1),
    );
  }
}
