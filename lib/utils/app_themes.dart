import 'package:flutter/material.dart';

/// Each color theme provides both a light and dark variant.
/// Dark mode is a separate setting that applies to whichever color theme is selected.
class AppThemes {
  AppThemes._();

  // ── Color Theme Definitions ───────────────────────────
  // Each has a light and dark version sharing the same seed color.

  static final Map<String, ThemeData> light = {
    'Forest': _light(seed: Color(0xFF2D6A4F), surface: Color(0xFFF0F7F4), card: Color(0xFFE8F5E9)),
    'Terracotta': _light(seed: Color(0xFFBC6C25), surface: Color(0xFFFEF9F0), card: Color(0xFFFFF3E0)),
    'Ocean': _light(seed: Color(0xFF0077B6), surface: Color(0xFFF0F8FF), card: Color(0xFFE3F2FD)),
    'Plum': _light(seed: Color(0xFF7B2D8E), surface: Color(0xFFF9F0F5), card: Color(0xFFF3E5F5)),
  };

  static final Map<String, ThemeData> dark = {
    'Forest': _dark(seed: Color(0xFF66BB6A), surface: Color(0xFF0D1F12), card: Color(0xFF1A2E1F)),
    'Terracotta': _dark(seed: Color(0xFFFF8A65), surface: Color(0xFF1A1008), card: Color(0xFF2E1E10)),
    'Ocean': _dark(seed: Color(0xFF42A5F5), surface: Color(0xFF0A1628), card: Color(0xFF122040)),
    'Plum': _dark(seed: Color(0xFFBA68C8), surface: Color(0xFF180A20), card: Color(0xFF261035)),
  };

  static const List<String> themeNames = ['Forest', 'Terracotta', 'Ocean', 'Plum'];

  /// Get the correct theme based on theme name + brightness
  static ThemeData getTheme(String name, Brightness brightness) {
    final map = brightness == Brightness.dark ? dark : light;
    return map[name] ?? light['Forest']!;
  }

  // ── Light builder ─────────────────────────────────────

  static ThemeData _light({
    required Color seed,
    required Color surface,
    required Color card,
  }) {
    final cs = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      surface: surface,
    );
    return _build(cs, surface, card, Brightness.light);
  }

  // ── Dark builder ──────────────────────────────────────

  static ThemeData _dark({
    required Color seed,
    required Color surface,
    required Color card,
  }) {
    final cs = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      surface: surface,
    );
    return _build(cs, surface, card, Brightness.dark);
  }

  // ── Shared styling ────────────────────────────────────

  static ThemeData _build(
    ColorScheme cs,
    Color surface,
    Color card,
    Brightness brightness,
  ) {
    return ThemeData(
      colorScheme: cs,
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: surface,
      appBarTheme: AppBarTheme(
        backgroundColor: card,
        foregroundColor: cs.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      listTileTheme: ListTileThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: cs.primaryContainer,
        elevation: 2,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: cs.primary, width: 2),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
