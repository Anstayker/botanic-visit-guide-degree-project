import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextTheme _appTextTheme(TextTheme base) {
  final lexendBase = GoogleFonts.lexendTextTheme(base);

  return lexendBase.copyWith(
    displayLarge: GoogleFonts.montserrat(textStyle: lexendBase.displayLarge),
    displayMedium: GoogleFonts.montserrat(textStyle: lexendBase.displayMedium),
    displaySmall: GoogleFonts.montserrat(textStyle: lexendBase.displaySmall),
    headlineLarge: GoogleFonts.montserrat(textStyle: lexendBase.headlineLarge),
    headlineMedium: GoogleFonts.montserrat(
      textStyle: lexendBase.headlineMedium,
    ),
    headlineSmall: GoogleFonts.montserrat(textStyle: lexendBase.headlineSmall),
    titleLarge: GoogleFonts.montserrat(textStyle: lexendBase.titleLarge),
    titleMedium: GoogleFonts.montserrat(textStyle: lexendBase.titleMedium),
    titleSmall: GoogleFonts.montserrat(textStyle: lexendBase.titleSmall),
  );
}

ThemeData defaultTheme() {
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Colors.green,
    brightness: Brightness.light,
  );
  final textTheme = _appTextTheme(ThemeData.light().textTheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: colorScheme.surfaceContainerLowest,
      elevation: 2,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.secondary,
      circularTrackColor: colorScheme.surfaceContainerHighest,
    ),
  );
}

ThemeData floraTheme() {
  const Color terracotta = Color(0xFFC26E59);
  const Color cream = Color(0xFFF7F3E8);
  const Color mustard = Color(0xFFE5A93B);

  final colorScheme = ColorScheme.fromSeed(
    seedColor: terracotta,
    brightness: Brightness.light,
    surface: cream,
  );
  final textTheme = _appTextTheme(ThemeData.light().textTheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    textTheme: textTheme,
    scaffoldBackgroundColor: colorScheme.surface,
    visualDensity: VisualDensity.adaptivePlatformDensity,

    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: terracotta,
      surfaceTintColor: Colors.transparent,
      // actionsIconTheme: IconThemeData(color: terracotta),
      elevation: 0,
      centerTitle: false,
    ),

    cardTheme: CardThemeData(
      color: Colors.white.withValues(alpha: 0.85),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
    ),

    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: mustard,
      linearTrackColor: terracotta.withValues(alpha: 0.2),
      circularTrackColor: colorScheme.surfaceContainerHighest,
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: terracotta,
      foregroundColor: cream,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: cream,
      selectedColor: terracotta,
      checkmarkColor: cream,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      side: WidgetStateBorderSide.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const BorderSide(color: Colors.transparent);
        }
        return BorderSide(color: terracotta.withValues(alpha: 0.3), width: 1);
      }),
      labelStyle: WidgetStateTextStyle.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.lexend(color: cream, fontWeight: FontWeight.bold);
        }
        return GoogleFonts.lexend(
          color: terracotta,
          fontWeight: FontWeight.normal,
        );
      }),
    ),
  );
}
