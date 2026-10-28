import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

abstract class AppColors {
  // Colores base.
  static const Color azureMist = Color(0xFFEAF0E8);
  static const Color lightGreen = Color(0xFFA6FF00);
  static const Color sageGreen = Color(0xFF78A832);
  static const Color oliveLeaf = Color(0xFF202522);
  static const Color charcoalBrown = Color(0xFF080909);

  // Mapeo semántico
  static const Color background = charcoalBrown;
  static const Color surface = Color(0xFF101112);
  static const Color cardBg = Color(0xFF17191A);
  static const Color accentGreen = lightGreen;

  // Textos y contraste.
  static const Color textPrimary = azureMist;
  static const Color textSecondary = Color(0xBFEAF0E8);
  static const Color textMuted = Color(0x80EAF0E8);
  static const Color textDark = Color(0xFF10130A);

  // Estados.
  static const Color errorRed = Color(0xFFFF6B6B);
  static const Color successGreen = lightGreen;

  static TextStyle dayTitleStyle = const TextStyle(
    fontSize: 46,
    fontWeight: FontWeight.w800,
    height: 0.9,
    letterSpacing: 4,
    color: lightGreen,
  );
}

class AppTheme {
  static TextStyle get dayTitleStyle => const TextStyle(
    fontSize: 46,
    fontWeight: FontWeight.w800,
    height: 0.9,
    letterSpacing: 4,
    color: AppColors.lightGreen,
  );

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.lightGreen,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lightGreen,
        onPrimary: AppColors.textDark,
        secondary: AppColors.sageGreen,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.errorRed,
        onError: Colors.white,
      ),

      // Tipografía global.
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: 22,
        ),
        bodyLarge: TextStyle(color: AppColors.textPrimary, fontSize: 16),
        bodyMedium: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        labelLarge: TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),

      iconTheme: const IconThemeData(color: AppColors.textSecondary),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Tarjetas
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.sageGreen.withValues(alpha: 0.22),
            width: 1,
          ),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: AppColors.textPrimary.withValues(alpha: 0.10),
        thickness: 1,
        space: 1,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.lightGreen,
        suffixIconColor: AppColors.textSecondary,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.textPrimary.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lightGreen, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightGreen,
          foregroundColor: AppColors.textDark,
          disabledBackgroundColor: AppColors.sageGreen,
          disabledForegroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          side: BorderSide(
            color: AppColors.sageGreen.withValues(alpha: 0.65),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.cardBg,
        contentTextStyle: const TextStyle(color: AppColors.textPrimary),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.sageGreen.withValues(alpha: 0.25)),
        ),
      ),
    );
  }
}
