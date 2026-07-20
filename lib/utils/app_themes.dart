import 'package:flutter/material.dart';

class AppThemes {
  AppThemes._();

  // ── Light Themes ──────────────────────────────────────

  static final ThemeData forestLight = _buildLight(
    name: 'Forest',
    seed: Color(0xFF2D6A4F),
    surface: Color(0xFFF0F7F4),
    card: Color(0xFFE8F5E9),
  );

  static final ThemeData terracottaLight = _buildLight(
    name: 'Terracotta',
    seed: Color(0xFFBC6C25),
    surface: Color(0xFFFEF9F0),
    card: Color(0xFFFFF3E0),
  );

  static final ThemeData oceanLight = _buildLight(
    name: 'Ocean',
    seed: Color(0xFF0077B6),
    surface: Color(0xFFF0F8FF),
    card: Color(0xFFE3F2FD),
  );

  static final ThemeData plumLight = _buildLight(
    name: 'Plum',
    seed: Color(0xFF7B2D8E),
    surface: Color(0xFFF9F0F5),
    card: Color(0xFFF3E5F5),
  );

  // ── Dark Themes ───────────────────────────────────────

  static final ThemeData midnightDark = _buildDark(
    name: 'Midnight',
    seed: Color(0xFF90CAF9),
    surface: Color(0xFF000000),
    card: Color(0xFF121212),
  );

  static final ThemeData carbonDark = _buildDark(
    name: 'Carbon',
    seed: Color(0xFF42A5F5),
    surface: Color(0xFF1A1A2E),
    card: Color(0xFF16213E),
  );

  static final ThemeData obsidianDark = _buildDark(
    name: 'Obsidian',
    seed: Color(0xFFFFB74D),
    surface: Color(0xFF1C1C1C),
    card: Color(0xFF2D2D2D),
  );

  static final ThemeData forestDark = _buildDark(
    name: 'Deep Forest',
    seed: Color(0xFF66BB6A),
    surface: Color(0xFF0D1F12),
    card: Color(0xFF1A2E1F),
  );

  // ── Theme Lists ───────────────────────────────────────

  static final List<ThemeData> lightThemes = [
    forestLight,
    terracottaLight,
    oceanLight,
    plumLight,
  ];

  static final List<ThemeData> darkThemes = [
    midnightDark,
    carbonDark,
    obsidianDark,
    forestDark,
  ];

  static final List<ThemeData> allThemes = [...lightThemes, ...darkThemes];

  static String themeName(ThemeData theme) {
    for (final t in allThemes) {
      if (t == theme) {
        return t.brightness == Brightness.light
            ? lightThemes[t == theme ? lightThemes.indexOf(t) : 0].toString()
            : darkThemes[t == theme ? darkThemes.indexOf(t) : 0].toString();
      }
    }
    return 'Default';
  }

  // ── Helpers ───────────────────────────────────────────

  static ThemeData _buildLight({
    required String name,
    required Color seed,
    required Color surface,
    required Color card,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.light,
      surface: surface,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: surface,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.inversePrimary,
        foregroundColor: colorScheme.onSurface,
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
        indicatorColor: colorScheme.primaryContainer,
        elevation: 2,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
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
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
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

  static ThemeData _buildDark({
    required String name,
    required Color seed,
    required Color surface,
    required Color card,
  }) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: seed,
      brightness: Brightness.dark,
      surface: surface,
    );

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      appBarTheme: AppBarTheme(
        backgroundColor: card,
        foregroundColor: colorScheme.onSurface,
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
        indicatorColor: colorScheme.primaryContainer,
        elevation: 2,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
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
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
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

// ── Named Theme Index ──────────────────────────────────
// Used to persist/restore theme selection

class ThemeEntry {
  final String name;
  final int index;
  final bool isDark;

  const ThemeEntry({
    required this.name,
    required this.index,
    required this.isDark,
  });

  ThemeData get theme {
    if (isDark) {
      return AppThemes.darkThemes[index];
    }
    return AppThemes.lightThemes[index];
  }

  static const List<ThemeEntry> all = [
    ThemeEntry(name: 'Forest', index: 0, isDark: false),
    ThemeEntry(name: 'Terracotta', index: 1, isDark: false),
    ThemeEntry(name: 'Ocean', index: 2, isDark: false),
    ThemeEntry(name: 'Plum', index: 3, isDark: false),
    ThemeEntry(name: 'Midnight', index: 0, isDark: true),
    ThemeEntry(name: 'Carbon', index: 1, isDark: true),
    ThemeEntry(name: 'Obsidian', index: 2, isDark: true),
    ThemeEntry(name: 'Deep Forest', index: 3, isDark: true),
  ];

  static ThemeEntry byName(String name) =>
      all.firstWhere((e) => e.name == name, orElse: () => all[0]);
}
