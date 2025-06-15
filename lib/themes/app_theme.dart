import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: _lightColorScheme,
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: _lightColorScheme.primary,
        foregroundColor: _lightColorScheme.onPrimary,
        iconTheme: IconThemeData(color: _lightColorScheme.onPrimary),
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _lightColorScheme.primary,
        foregroundColor: _lightColorScheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightColorScheme.primary,
          foregroundColor: _lightColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: _lightColorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _lightColorScheme.primary),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.normal,
            letterSpacing: -0.25,
            fontFamily: "DMSerif"),
        displayMedium: TextStyle(
            fontSize: 45, fontWeight: FontWeight.normal, fontFamily: "DMSerif"),
        displaySmall: TextStyle(
            fontSize: 36, fontWeight: FontWeight.normal, fontFamily: "DMSerif"),
        headlineLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w400, fontFamily: "DMSerif"),
        headlineMedium: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w400, fontFamily: "DMSerif"),
        headlineSmall: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w400, fontFamily: "DMSerif"),
        titleLarge: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, fontFamily: "DMSans"),
        titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            fontFamily: "DMSans"),
        titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            fontFamily: "DMSans"),
        bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
            fontFamily: "DMSans"),
        bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.25,
            fontFamily: "DMSans"),
        bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.4,
            fontFamily: "DMSans"),
        labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            fontFamily: "DMSans"),
        labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            fontFamily: "DMSans"),
        labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            fontFamily: "DMSans"),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: _darkColorScheme,
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: _darkColorScheme.primary,
        foregroundColor: _darkColorScheme.onPrimary,
        iconTheme: IconThemeData(color: _darkColorScheme.onPrimary),
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _darkColorScheme.primary,
        foregroundColor: _darkColorScheme.onPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkColorScheme.primary,
          foregroundColor: _darkColorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: _darkColorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkColorScheme.primary),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontSize: 57,
            fontWeight: FontWeight.normal,
            letterSpacing: -0.25,
            fontFamily: "DMSerif"),
        displayMedium: TextStyle(
            fontSize: 45, fontWeight: FontWeight.normal, fontFamily: "DMSerif"),
        displaySmall: TextStyle(
            fontSize: 36, fontWeight: FontWeight.normal, fontFamily: "DMSerif"),
        headlineLarge: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w400, fontFamily: "DMSerif"),
        headlineMedium: TextStyle(
            fontSize: 28, fontWeight: FontWeight.w400, fontFamily: "DMSerif"),
        headlineSmall: TextStyle(
            fontSize: 24, fontWeight: FontWeight.w400, fontFamily: "DMSerif"),
        titleLarge: TextStyle(
            fontSize: 22, fontWeight: FontWeight.bold, fontFamily: "DMSans"),
        titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.15,
            fontFamily: "DMSans"),
        titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
            fontFamily: "DMSans"),
        bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.5,
            fontFamily: "DMSans"),
        bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.25,
            fontFamily: "DMSans"),
        bodySmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            letterSpacing: 0.4,
            fontFamily: "DMSans"),
        labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
            fontFamily: "DMSans"),
        labelMedium: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            fontFamily: "DMSans"),
        labelSmall: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            fontFamily: "DMSans"),
      ),
    );
  }

  static final ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: const Color(0xFF386641), // Hunter Green
    onPrimary: const Color(0xFFFFFFFF), // White (for text/icons on primary)
    primaryContainer: const Color(
        0xFFA4CDAC), // Lighter shade of Hunter Green (e.g., hunter_green.800)
    onPrimaryContainer:
        const Color(0xFF0B140D), // Dark text for onPrimaryContainer

    secondary: const Color(0xFF6A994E), // Asparagus
    onSecondary: const Color(0xFFFFFFFF), // White (for text/icons on secondary)
    secondaryContainer:
        const Color(0xFFC2D9B5), // Lighter Asparagus (e.g., asparagus.800)
    onSecondaryContainer:
        const Color(0xFF151E10), // Dark text for onSecondaryContainer

    tertiary: const Color(0xFFA7C957), // Yellow Green
    onTertiary: const Color(
        0xFF222B0E), // Darkest Yellow Green (for text/icons on tertiary)
    tertiaryContainer: const Color(
        0xFFDBE9BB), // Lighter Yellow Green (e.g., yellow_green.800)
    onTertiaryContainer:
        const Color(0xFF222B0E), // Dark text for onTertiaryContainer

    error: const Color(0xFFBC4749), // Bittersweet Shimmer
    onError: const Color(0xFFFFFFFF), // White (for text/icons on error)
    errorContainer: const Color(
        0xFFF2DADB), // Lighter Bittersweet (e.g., bittersweet_shimmer.900)
    onErrorContainer: const Color(
        0xFF260E0E), // Very Dark Green (hunter_green.100 for text on parchment)

    surface: const Color(
        0xFFF7F1E2), // Lighter Parchment (parchment.700 for cards, dialogs)
    onSurface: const Color(
        0xFF0B140D), // Very Dark Green (hunter_green.100 for text on surface)

    surfaceContainerHighest:
        const Color(0xFFF4EDD9), // Another Parchment variant (parchment.600)
    onSurfaceVariant:
        const Color(0xFF0B140D), // Very Dark Green (hunter_green.100)

    outline: const Color(
        0xFFA4CDAC), // Light Hunter Green (hunter_green.800 for borders)
    outlineVariant: const Color(
        0xFF77B483), // Medium Hunter Green (hunter_green.700 for subtle borders)

    shadow: const Color(0xFF000000), // Black (standard shadow)
    scrim: const Color(0xFF000000), // Black (standard scrim)

    inverseSurface: const Color(
        0xFF223D27), // Dark Green (hunter_green.300, for elements on an inverted background)
    onInverseSurface:
        const Color(0xFFFCFAF5), // Lightest Parchment (parchment.900)
    inversePrimary: const Color(
        0xFF77B483), // A hunter green shade suitable for dark backgrounds (hunter_green.700)
    surfaceTint: const Color(
        0xFF386641), // Hunter Green (often same as primary for surface elevation tint)
  );

// --- Dark Theme ColorScheme ---
  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF6A994E), // Asparagus (Primary for dark theme)
    onPrimary: Color(
        0xFF151E10), // Darkest Asparagus (asparagus.100 for text on primary)
    primaryContainer:
        Color(0xFF3F5B2F), // Darker Asparagus (e.g., asparagus.300)
    onPrimaryContainer: Color(0xFFE1ECDA), // Lightest Asparagus (asparagus.900)

    secondary: Color(0xFFA7C957), // Yellow Green
    onSecondary: Color(
        0xFF222B0E), // Darkest Yellow Green (yellow_green.100 for text on secondary)
    secondaryContainer:
        Color(0xFF67812A), // Darker Yellow Green (e.g., yellow_green.300)
    onSecondaryContainer:
        Color(0xFFEDF4DD), // Lightest Yellow Green (yellow_green.900)

    tertiary: Color(
        0xFF51935E), // Hunter Green 600 (as a less prominent accent in dark)
    onTertiary: Color(0xFFD2E6D6), // Lightest Hunter Green (hunter_green.900)
    tertiaryContainer:
        Color(0xFF223D27), // Darker Hunter Green (e.g., hunter_green.300)
    onTertiaryContainer:
        Color(0xFFA4CDAC), // Lighter Hunter Green (hunter_green.800)

    error: Color(
        0xFFCA6C6E), // Bittersweet Shimmer 600 (slightly lighter red for dark mode)
    onError: Color(0xFF260E0E), // Darkest Bittersweet (bittersweet_shimmer.100)
    errorContainer:
        Color(0xFF73292B), // Darker Bittersweet (e.g., bittersweet_shimmer.300)
    onErrorContainer: Color(
        0xFFF2DADB), // Lightest Parchment (parchment.900 for text on dark background)

    surface: Color(
        0xFF16291A), // Dark Hunter Green (hunter_green.200 for cards, dialogs)
    onSurface: Color(
        0xFFFCFAF5), // Lightest Parchment (parchment.900 for text on surface)

    surfaceContainerHighest:
        Color(0xFF223D27), // Darker Hunter Green (hunter_green.300)
    onSurfaceVariant:
        Color(0xFFD2E6D6), // Lightest Hunter Green (hunter_green.900)

    outline: Color(
        0xFF2D5234), // Medium-Dark Hunter Green (hunter_green.400 for borders)
    outlineVariant: Color(
        0xFF223D27), // Darker Hunter Green (hunter_green.300 for subtle borders)

    shadow: Color(0xFF000000), // Black
    scrim: Color(0xFF000000), // Black

    inverseSurface: Color(0xFFF7F1E2), // Lighter Parchment (parchment.700)
    onInverseSurface:
        Color(0xFF0B140D), // Very Dark Hunter Green (hunter_green.100)
    inversePrimary: Color(
        0xFF386641), // Hunter Green (for elements on an inverted light background)
    surfaceTint: Color(
        0xFF6A994E), // Asparagus (often same as primary for surface elevation tint in dark)
  );

  /*
  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xff006e1c),
    surfaceTint: Color(0xff006e1c),
    onPrimary: Color(0xffffffff),
    primaryContainer: Color(0xff4caf50),
    onPrimaryContainer: Color(0xff003c0b),
    secondary: Color(0xff0b6b1d),
    onSecondary: Color(0xffffffff),
    secondaryContainer: Color(0xff2e8534),
    onSecondaryContainer: Color(0xfff7fff1),
    tertiary: Color(0xff286b33),
    onTertiary: Color(0xffffffff),
    tertiaryContainer: Color(0xff81c784),
    onTertiaryContainer: Color(0xff09541e),
    error: Color(0xffaf101a),
    onError: Color(0xffffffff),
    errorContainer: Color(0xffd32f2f),
    onErrorContainer: Color(0xfffff2f0),
    surface: Color(0xfffcf8f8),
    onSurface: Color(0xff1c1b1b),
    onSurfaceVariant: Color(0xff444748),
    outline: Color(0xff747878),
    outlineVariant: Color(0xffc4c7c7),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xff313030),
    inversePrimary: Color(0xff78dc77),
    primaryFixed: Color(0xff94f990),
    onPrimaryFixed: Color(0xff002204),
    primaryFixedDim: Color(0xff78dc77),
    onPrimaryFixedVariant: Color(0xff005313),
    secondaryFixed: Color(0xff9df898),
    onSecondaryFixed: Color(0xff002204),
    secondaryFixedDim: Color(0xff82db7e),
    onSecondaryFixedVariant: Color(0xff005312),
    tertiaryFixed: Color(0xffabf4ac),
    onTertiaryFixed: Color(0xff002107),
    tertiaryFixedDim: Color(0xff90d792),
    onTertiaryFixedVariant: Color(0xff07521d),
    surfaceDim: Color(0xffddd9d9),
    surfaceBright: Color(0xfffcf8f8),
    surfaceContainerLowest: Color(0xffffffff),
    surfaceContainerLow: Color(0xfff6f3f2),
    surfaceContainer: Color(0xfff1edec),
    surfaceContainerHigh: Color(0xffebe7e7),
    surfaceContainerHighest: Color(0xffe5e2e1),
  );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xff78dc77),
    surfaceTint: Color(0xff78dc77),
    onPrimary: Color(0xff00390a),
    primaryContainer: Color(0xff4caf50),
    onPrimaryContainer: Color(0xff003c0b),
    secondary: Color(0xff82db7e),
    onSecondary: Color(0xff00390a),
    secondaryContainer: Color(0xff4da24e),
    onSecondaryContainer: Color(0xff001702),
    tertiary: Color(0xff9ce39e),
    onTertiary: Color(0xff003911),
    tertiaryContainer: Color(0xff81c784),
    onTertiaryContainer: Color(0xff09541e),
    error: Color(0xffffb3ac),
    onError: Color(0xff680008),
    errorContainer: Color(0xffd32f2f),
    onErrorContainer: Color(0xfffff2f0),
    surface: Color(0xff141313),
    onSurface: Color(0xffe5e2e1),
    onSurfaceVariant: Color(0xffc4c7c7),
    outline: Color(0xff8e9192),
    outlineVariant: Color(0xff444748),
    shadow: Color(0xff000000),
    scrim: Color(0xff000000),
    inverseSurface: Color(0xffe5e2e1),
    inversePrimary: Color(0xff006e1c),
    primaryFixed: Color(0xff94f990),
    onPrimaryFixed: Color(0xff002204),
    primaryFixedDim: Color(0xff78dc77),
    onPrimaryFixedVariant: Color(0xff005313),
    secondaryFixed: Color(0xff9df898),
    onSecondaryFixed: Color(0xff002204),
    secondaryFixedDim: Color(0xff82db7e),
    onSecondaryFixedVariant: Color(0xff005312),
    tertiaryFixed: Color(0xffabf4ac),
    onTertiaryFixed: Color(0xff002107),
    tertiaryFixedDim: Color(0xff90d792),
    onTertiaryFixedVariant: Color(0xff07521d),
    surfaceDim: Color(0xff141313),
    surfaceBright: Color(0xff3a3939),
    surfaceContainerLowest: Color(0xff0f0e0e),
    surfaceContainerLow: Color(0xff1c1b1b),
    surfaceContainer: Color(0xff201f1f),
    surfaceContainerHigh: Color(0xff2a2929),
    surfaceContainerHighest: Color(0xff353434),
  );
  */
}
