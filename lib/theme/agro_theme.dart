import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AgroTheme {
  // Colores principales según diseño Stitch Light
  static const Color primaryGreen = Color(0xFF2E5A27);
  static const Color secondaryYellow = Color(0xFFF5A623);
  static const Color backgroundCream = Color(0xFFF9FAF2);
  static const Color surfaceWhite = Colors.white;
  static const Color textDark = Color(0xFF1A1C18);
  static const Color textMuted = Color(0xFF72796D);
  static const Color errorRed = Color(0xFFBA1A1A);

  // Colores para iconos pastel
  static const Color iconBgBlue = Color(0xFFE3F2FD);
  static const Color iconBgOrange = Color(0xFFFFF3E0);
  static const Color iconBgGreen = Color(0xFFE8F5E9);
  static const Color iconBgPurple = Color(0xFFF3E5F5);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        secondary: secondaryYellow,
        surface: surfaceWhite,
        error: errorRed,
      ),
      scaffoldBackgroundColor: backgroundCream,
      textTheme: GoogleFonts.openSansTextTheme().copyWith(
        displayLarge: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        headlineMedium: GoogleFonts.roboto(
          fontWeight: FontWeight.bold,
          color: textDark,
        ),
        titleLarge: GoogleFonts.roboto(
          fontWeight: FontWeight.w600,
          color: textDark,
        ),
        bodyLarge: GoogleFonts.openSans(
          color: textDark,
          fontSize: 16,
        ),
        bodyMedium: GoogleFonts.openSans(
          color: textDark,
          fontSize: 14,
        ),
        bodySmall: GoogleFonts.openSans(
          color: textMuted,
          fontSize: 12,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceWhite,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFC2C9BB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFFC2C9BB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  // Degradado para la tarjeta de saldo
  static LinearGradient get balanceGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF1A4314), // Deep organic forest green
          Color(0xFF2D6A4F), // Vibrant emerald
          Color(0xFF1E4620), // Rich dark green
        ],
      );

  static LinearGradient get premiumGoldGradient => const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFF5A623),
          Color(0xFFFFD54F),
        ],
      );
}
