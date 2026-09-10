import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Sikkim Sanctuary Palette (Stitch Project 17691297282002078409)
  static const Color primaryEmerald = Color(0xFF112D23); // Primary Alpine Emerald
  static const Color primaryDarkPine = Color(0xFF0C241B);
  static const Color secondaryTerracotta = Color(0xFFE06D28); // Radiant Terracotta Gold
  static const Color secondarySaffron = Color(0xFFFE843E); // Warm Tibetan Saffron
  static const Color tertiarySage = Color(0xFF2D6A4F); // Deep Sanctuary Sage
  static const Color accentAmber = Color(0xFFD97706); // High Altitude Warning Saffron
  static const Color surfaceCanvas = Color(0xFFF4FBF4); // Sandstone Base Canvas
  static const Color cardLowest = Color(0xFFFFFFFF); // Pure White Card Floating
  static const Color cardLow = Color(0xFFEEF5EF); // Muted Surface Tier
  static const Color cardHigh = Color(0xFFE3EAE3);
  static const Color textOnSurface = Color(0xFF161D19);
  static const Color textMuted = Color(0xFF424845);

  // Legacy mappings for backwards compatibility
  static const Color primaryOrange = secondaryTerracotta;
  static const Color monasteryCrimson = primaryEmerald;
  static const Color warmGold = secondarySaffron;

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: primaryEmerald,
    scaffoldBackgroundColor: surfaceCanvas,
    colorScheme: const ColorScheme.light(
      primary: primaryEmerald,
      secondary: secondaryTerracotta,
      tertiary: tertiarySage,
      surface: surfaceCanvas,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: textOnSurface,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      headlineLarge: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, color: primaryEmerald),
      headlineMedium: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: primaryEmerald),
      headlineSmall: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w600, color: primaryEmerald),
      titleMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: primaryEmerald),
      labelLarge: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: primaryEmerald),
      labelMedium: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: textMuted),
      labelSmall: GoogleFonts.outfit(fontWeight: FontWeight.w700, letterSpacing: 0.8),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: surfaceCanvas.withOpacity(0.85),
      elevation: 0,
      scrolledUnderElevation: 0,
      iconTheme: const IconThemeData(color: primaryEmerald),
      titleTextStyle: GoogleFonts.plusJakartaSans(
        color: primaryEmerald,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0x12112D23)),
      ),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryEmerald,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: const StadiumBorder(),
        textStyle: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16),
      ),
    ),
  );

  static ThemeData darkTheme = lightTheme;
}
