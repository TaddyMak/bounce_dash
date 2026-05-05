import 'package:flutter/material.dart';

ThemeData buildBounceDashTheme() {
  const sky = Color(0xFF63D5FF);
  const sun = Color(0xFFFFC857);
  const coral = Color(0xFFFF6B6B);
  const ink = Color(0xFF12304A);
  const mint = Color(0xFF6EE7B7);
  const paper = Color(0xFFF7FBFF);

  final scheme = ColorScheme.fromSeed(
    seedColor: coral,
    brightness: Brightness.light,
    primary: coral,
    secondary: mint,
    surface: paper,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: paper,
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w900,
        letterSpacing: -1.2,
        color: ink,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: ink,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: ink,
      ),
      bodyMedium: TextStyle(fontSize: 14, color: ink),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: ink,
      elevation: 0,
      centerTitle: true,
    ),
    cardTheme: CardThemeData(
      color: Colors.white.withValues(alpha: 0.9),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      margin: EdgeInsets.zero,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: coral,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(58),
        textStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 17,
          letterSpacing: 0.1,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        minimumSize: const Size.fromHeight(56),
        side: BorderSide(color: ink.withValues(alpha: 0.15)),
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: sun.withValues(alpha: 0.2),
      selectedColor: sun,
      labelStyle: const TextStyle(fontWeight: FontWeight.w700, color: ink),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
    ),
    extensions: const [
      BounceDashPalette(
        skyTop: sky,
        skyBottom: Color(0xFFB7F7FF),
        accentWarm: sun,
        accentDanger: coral,
      ),
    ],
  );
}

class BounceDashPalette extends ThemeExtension<BounceDashPalette> {
  const BounceDashPalette({
    required this.skyTop,
    required this.skyBottom,
    required this.accentWarm,
    required this.accentDanger,
  });

  final Color skyTop;
  final Color skyBottom;
  final Color accentWarm;
  final Color accentDanger;

  @override
  ThemeExtension<BounceDashPalette> copyWith({
    Color? skyTop,
    Color? skyBottom,
    Color? accentWarm,
    Color? accentDanger,
  }) {
    return BounceDashPalette(
      skyTop: skyTop ?? this.skyTop,
      skyBottom: skyBottom ?? this.skyBottom,
      accentWarm: accentWarm ?? this.accentWarm,
      accentDanger: accentDanger ?? this.accentDanger,
    );
  }

  @override
  ThemeExtension<BounceDashPalette> lerp(
    covariant ThemeExtension<BounceDashPalette>? other,
    double t,
  ) {
    if (other is! BounceDashPalette) {
      return this;
    }

    return BounceDashPalette(
      skyTop: Color.lerp(skyTop, other.skyTop, t) ?? skyTop,
      skyBottom: Color.lerp(skyBottom, other.skyBottom, t) ?? skyBottom,
      accentWarm: Color.lerp(accentWarm, other.accentWarm, t) ?? accentWarm,
      accentDanger:
          Color.lerp(accentDanger, other.accentDanger, t) ?? accentDanger,
    );
  }
}
