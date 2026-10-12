import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  /// Builds the Material 3 Expressive theme, optionally using dynamic colors
  static ThemeData buildTheme({
    ColorScheme? dynamicColorScheme,
    required Brightness brightness,
  }) {
    final isDark = brightness == Brightness.dark;

    // Use dynamic color if available, otherwise generate from our primary brand color
    var colorScheme = dynamicColorScheme?.copyWith(brightness: brightness) ??
        ColorScheme.fromSeed(
          seedColor: AppColors.primary, // Brand color
          brightness: brightness,
        );

    if (!isDark) {
      // Fix auto-generated dull/yellowish containers in light mode
      colorScheme = colorScheme.copyWith(
        primaryContainer: AppColors.primary,
        onPrimaryContainer: AppColors.onPrimary,
        surfaceContainerHighest: const Color(0xFFE2E8F0),
        outlineVariant: const Color(0xFFD2E3FC),
      );
    }

    // M3 Typography - using expressive, large, modern fonts
    final baseTextTheme = isDark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme;
        
    final textTheme = GoogleFonts.plusJakartaSansTextTheme(baseTextTheme).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );
    final titleTheme = GoogleFonts.outfitTextTheme(baseTextTheme).apply(
      bodyColor: colorScheme.onSurface,
      displayColor: colorScheme.onSurface,
    );

    final finalTextTheme = textTheme.copyWith(
      displayLarge: titleTheme.displayLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.5),
      displayMedium: titleTheme.displayMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: -1.0),
      displaySmall: titleTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
      headlineMedium: titleTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
      headlineSmall: titleTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: titleTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -0.5),
      titleMedium: titleTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      titleSmall: titleTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
      bodyLarge: textTheme.bodyLarge?.copyWith(fontSize: 16),
      bodyMedium: textTheme.bodyMedium?.copyWith(fontSize: 14),
      bodySmall: textTheme.bodySmall?.copyWith(fontSize: 12),
      labelLarge: textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.1),
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFFDF7F4),
      textTheme: finalTextTheme,
      iconTheme: IconThemeData(color: colorScheme.onSurface),
      dividerTheme: DividerThemeData(color: colorScheme.outlineVariant),
      listTileTheme: ListTileThemeData(
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
      ),
      
      // Modern M3 AppBar
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.appBarDarkBlue,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        actionsIconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: titleTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),

      // M3 Expressive Cards (Very rounded)
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: const Color(0xFFF5B5C3).withValues(alpha: 0.15),
        color: isDark ? colorScheme.surfaceContainer : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFF5B5C3), width: 1.0),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Pill-shaped Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFF5B5C3),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          side: const BorderSide(color: Color(0xFFF5B5C3), width: 1.5),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // M3 Floating Action Button (Rounded Rectangle, not circular)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 2,
        highlightElevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
      ),

      // Expressive Inputs — Rose Pink borders, Yellow focus (matches Auth screens)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3) : Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF5B5C3), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF5B5C3), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFF5C431), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1.5),
        ),
      ),

      // Dialogs
      dialogTheme: DialogThemeData(
        elevation: 0,
        shadowColor: const Color(0xFFF5B5C3).withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFF5B5C3), width: 1.0),
        ),
      ),
      
      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : const Color(0xFFFDF7F4),
        shadowColor: const Color(0xFFF5B5C3).withValues(alpha: 0.2),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          side: BorderSide(color: Color(0xFFF5B5C3), width: 1.0),
        ),
      ),
      
      // Chips
      chipTheme: ChipThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        side: const BorderSide(color: Color(0xFFF5B5C3), width: 1.0),
      ),
    );
  }

  // Compatibility getters for files that might still call AppTheme.lightTheme directly
  static ThemeData get lightTheme => buildTheme(brightness: Brightness.light);
  static ThemeData get darkTheme => buildTheme(brightness: Brightness.dark);
}
