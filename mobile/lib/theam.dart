import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  AppTheme._();

  // =========================
  // Brand & Core Colors
  // =========================
  static const Color primary = Color(0xFFF39C12); // AbuKaf main brand color
  static const Color primaryAccent = Color(0xFFB45309); // Darker accent

  // =========================
  // Backgrounds
  // =========================
  static const Color pageBackground = Color(0xFFF8FAFC);
  static const Color surfaceBackground = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // =========================
  // Text Colors
  // =========================
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF64748B);

  // =========================
  // Borders & Dividers
  // =========================
  static const Color borderSubtle = Color(0xFFE2E8F0);
  static const Color dividerColor = Color(0xFFE5E7EB);

  // =========================
  // Status Colors
  // =========================
  static const Color success = Color(0xFF16A34A);
  static const Color danger = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);

  static ThemeData light() {
    final scheme = ColorScheme(
      brightness: Brightness.light,
      primary: primary,
      onPrimary: Colors.white,
      secondary: primaryAccent,
      onSecondary: Colors.white,
      surface: surfaceBackground,
      onSurface: textPrimary,
      background: pageBackground,
      onBackground: textPrimary,
      error: danger,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: pageBackground,
      fontFamily: 'Cairo',

      // =========================
      // AppBar Theme (Top Bar)
      // =========================
      appBarTheme: const AppBarTheme(
        backgroundColor: surfaceBackground,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,

        // 🔒 System status bar protection (Wi-Fi / Time)
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: surfaceBackground,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // =========================
      // Navigation Bar (Bottom)
      // =========================
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceBackground,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: primary.withOpacity(0.15),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 12,
            color: states.contains(WidgetState.selected)
                ? primary
                : textSecondary,
          ),
        ),
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? primary
                : textSecondary,
          ),
        ),
      ),

      // =========================
      // Cards
      // =========================
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
          side: const BorderSide(color: borderSubtle),
        ),
        margin: EdgeInsets.zero,
      ),

      // =========================
      // Inputs
      // =========================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceBackground,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        hintStyle: const TextStyle(color: textMuted),
        labelStyle: const TextStyle(color: textSecondary),
        floatingLabelStyle: const TextStyle(color: primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: primary, width: 1.6),
        ),
      ),

      // =========================
      // Divider
      // =========================
      dividerTheme: const DividerThemeData(
        color: dividerColor,
        thickness: 1,
        space: 24,
      ),


      // =========================
      // Buttons (Material 3 Fix)
      // =========================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),


    );
  }
}
