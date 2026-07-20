import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_themes.dart';

class ThemePickerScreen extends StatefulWidget {
  final String currentName;
  final ValueChanged<String> onSelected;

  const ThemePickerScreen({
    super.key,
    required this.currentName,
    required this.onSelected,
  });

  @override
  State<ThemePickerScreen> createState() => _ThemePickerScreenState();
}

class _ThemePickerScreenState extends State<ThemePickerScreen> {
  late String _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.currentName;
  }

  Future<void> _select(String name) async {
    setState(() => _selected = name);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_name', name);
    widget.onSelected(name);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Color Theme'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: AppThemes.themeNames.map((name) {
          final theme = AppThemes.getTheme(name, brightness);
          final cs = theme.colorScheme;
          final isSelected = _selected == name;
          return Card(
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: () => _select(name),
              child: Container(
                height: 88,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Color preview block
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
                    // Name + description
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          // Preview dots
                          Row(
                            children: [
                              _Dot(color: cs.primary),
                              const SizedBox(width: 6),
                              _Dot(color: cs.secondary),
                              const SizedBox(width: 6),
                              _Dot(color: cs.tertiary),
                              const SizedBox(width: 10),
                              Text(
                                brightness == Brightness.dark ? 'Dark variant' : 'Light variant',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: cs.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: cs.primary, size: 26),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  const _Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 1,
        ),
      ),
    );
  }
}
