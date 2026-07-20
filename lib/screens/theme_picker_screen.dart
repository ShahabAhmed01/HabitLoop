import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_themes.dart';

class ThemePickerScreen extends StatefulWidget {
  final ThemeEntry currentTheme;
  final ValueChanged<ThemeEntry> onThemeChanged;

  const ThemePickerScreen({
    super.key,
    required this.currentTheme,
    required this.onThemeChanged,
  });

  @override
  State<ThemePickerScreen> createState() => _ThemePickerScreenState();
}

class _ThemePickerScreenState extends State<ThemePickerScreen> {
  late ThemeEntry _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentTheme;
  }

  Future<void> _selectTheme(ThemeEntry entry) async {
    setState(() => _selected = entry);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_name', entry.name);
    widget.onThemeChanged(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Theme'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionTitle('Light'),
          const SizedBox(height: 8),
          ...AppThemes.lightThemes.asMap().entries.map((entry) {
            final i = entry.key;
            final theme = entry.value;
            final themeEntry = ThemeEntry.all[i];
            final isSelected = _selected.name == themeEntry.name;
            return _ThemeTile(
              themeEntry: themeEntry,
              theme: theme,
              isSelected: isSelected,
              onTap: () => _selectTheme(themeEntry),
            );
          }),
          const SizedBox(height: 24),
          const _SectionTitle('Dark'),
          const SizedBox(height: 8),
          ...AppThemes.darkThemes.asMap().entries.map((entry) {
            final i = entry.key;
            final theme = entry.value;
            final themeEntry = ThemeEntry.all[i + 4];
            final isSelected = _selected.name == themeEntry.name;
            return _ThemeTile(
              themeEntry: themeEntry,
              theme: theme,
              isSelected: isSelected,
              onTap: () => _selectTheme(themeEntry),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  final ThemeEntry themeEntry;
  final ThemeData theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeTile({
    required this.themeEntry,
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 80,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.check, color: cs.onPrimary, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      themeEntry.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      themeEntry.isDark ? 'Dark theme' : 'Light theme',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(Icons.check_circle, color: cs.primary, size: 24),
              const SizedBox(width: 8),
              // Color preview dots
              Row(
                children: [
                  _ColorDot(color: cs.primary),
                  const SizedBox(width: 4),
                  _ColorDot(color: cs.secondary),
                  const SizedBox(width: 4),
                  _ColorDot(color: cs.tertiary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
