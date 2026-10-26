import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Paleta de colores oficial mapeada desde la imagen
abstract class AppColors {
  // Colores Base de la Paleta
  static const Color azureMist = Color(
    0xFFE6FAFC,
  ); // #E6FAFC - Fondo claro / Textos principales
  static const Color lightGreen = Color(
    0xFF9CFC97,
  ); // #9CFC97 - Acento neón vibrante / Botones primarios
  static const Color sageGreen = Color(
    0xFF6BA368,
  ); // #6BA368 - Verde medio / Bordes y detalles
  static const Color oliveLeaf = Color(
    0xFF515B3A,
  ); // #515B3A - Verde oliva oscuro / Tarjetas elevadas
  static const Color charcoalBrown = Color(
    0xFF353D2F,
  ); // #353D2F - Fondo oscuro principal

  // Mapeo Semántico
  static const Color background = charcoalBrown;
  static const Color surface = Color(
    0xFF2E3529,
  ); // Superficie ligeramente más oscura para capas
  static const Color cardBg = oliveLeaf;
  static const Color accentGreen = lightGreen;

  // Textos y Contraste
  static const Color textPrimary = azureMist;
  static const Color textSecondary = Color(0xB3E6FAFC); // Azure Mist al 70%
  static const Color textMuted = Color(0x80E6FAFC); // Azure Mist al 50%
  static const Color textDark = Color(
    0xFF1B2219,
  ); // Texto oscuro legible dentro de botones de acento

  // Estados
  static const Color errorRed = Color(0xFFFF6B6B);
  static const Color successGreen = lightGreen;
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      primaryColor: AppColors.lightGreen,

      // ColorScheme bien estructurado para Flutter 3+
      colorScheme: const ColorScheme.dark(
        primary: AppColors.lightGreen,
        onPrimary: AppColors.textDark,
        secondary: AppColors.sageGreen,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.cardBg,
        onSurface: AppColors.textPrimary,
        error: AppColors.errorRed,
        onError: Colors.white,
      ),

      // Tipografía Unificada
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

      // Estilo global para AppBar con control de System UI
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

      // Estilo de Tarjetas Modernas (Sutil brillo en bordes)
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.sageGreen.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),

      // Estilo de Campos de Texto (Inputs)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.azureMist.withValues(alpha: 0.05),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        prefixIconColor: AppColors.lightGreen,
        suffixIconColor: AppColors.sageGreen,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColors.azureMist.withValues(alpha: 0.12),
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

      // Botón Elevado Principal (Fondo verde neón con texto oscuro contrastado)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightGreen,
          foregroundColor: AppColors.textDark,
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

      // Botón Delineado Secundario
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          side: BorderSide(
            color: AppColors.sageGreen.withValues(alpha: 0.6),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      // Notificaciones / SnackBars
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.oliveLeaf,
        contentTextStyle: const TextStyle(color: AppColors.azureMist),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: AppColors.sageGreen.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}
