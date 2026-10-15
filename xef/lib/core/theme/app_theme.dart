import 'package:flutter/material.dart';

class AppColors {
  // Color Dominante y Fondos
  static const Color primaryDark = Color(0xFF000F4F); // Azul Dominante
  static const Color background = Color(0xFF000B3B); // Fondo Ultramar
  static const Color cardBg = Color(0xFF00177A); // Tarjetas y Elevaciones
  static const Color cardBgLight = Color(
    0xFF001D96,
  ); // Hover / Contenedores secundarios

  // Color de Acento (Bordes, Detalle y Botones Activos)
  static const Color accentGreen = Color(0xFF00FF19); // Verde Neón
  static const Color accentGreenGlow = Color(0x3300FF19); // Brillo verde suave

  // Textos y Estados
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);
  static const Color errorRed = Color(0xFFFF453A);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.primaryDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primaryDark,
        secondary: AppColors.accentGreen,
        surface: AppColors.cardBg,
      ),

      // Estilo de Tarjetas Modernas (Corregido a CardThemeData)
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.accentGreen.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),

      // Estilo de Inputs/Campos de Texto
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBg,
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.accentGreen.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.accentGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.errorRed, width: 1.5),
        ),
      ),

      // Botones Elevados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.accentGreen,
          elevation: 4,
          shadowColor: AppColors.accentGreen.withValues(alpha: 0.2),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.accentGreen, width: 1.5),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }
}
