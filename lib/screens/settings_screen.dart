import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../database/database_helper.dart';
import '../models/habit.dart';
import '../models/completion.dart';
import '../services/purchase_service.dart';
import 'theme_picker_screen.dart';

class SettingsScreen extends StatefulWidget {
  final String themeName;
  final ThemeMode themeMode;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<ThemeMode> onDarkModeChanged;

  const SettingsScreen({
    super.key,
    required this.themeName,
    required this.themeMode,
    required this.onThemeChanged,
    required this.onDarkModeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _darkModeLabel(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'Match System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          // ── Appearance ──
          const _SectionHeader('Appearance'),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Color Theme'),
            subtitle: Text(widget.themeName),
            trailing: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onTap: () async {
              final result = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (_) => ThemePickerScreen(
                    currentName: widget.themeName,
                    onSelected: widget.onThemeChanged,
                  ),
                ),
              );
              if (result != null) widget.onThemeChanged(result);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            subtitle: Text(_darkModeLabel(widget.themeMode)),
            trailing: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  icon: Icon(Icons.brightness_auto, size: 18),
                  label: Text('Auto'),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  icon: Icon(Icons.light_mode, size: 18),
                  label: Text('Light'),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  icon: Icon(Icons.dark_mode, size: 18),
                  label: Text('Dark'),
                ),
              ],
              selected: {widget.themeMode},
              onSelectionChanged: (selected) {
                widget.onDarkModeChanged(selected.first);
              },
            ),
          ),
          const Divider(),

          // ── Data ──
          const _SectionHeader('Data'),
          ListTile(
            leading: const Icon(Icons.upload),
            title: const Text('Export Data'),
            subtitle: const Text('Copy habit data to clipboard'),
            onTap: () => _exportData(context),
          ),
          ListTile(
            leading: const Icon(Icons.download),
            title: const Text('Import Data'),
            subtitle: const Text('Paste habit data from clipboard'),
            onTap: () => _importData(context),
          ),
          const Divider(),

          // ── Support ──
          const _SectionHeader('Support'),
          SwitchListTile(
            secondary: const Icon(Icons.remove_circle_outline),
            title: const Text('Remove Ads'),
            subtitle: Text(PurchaseService.adsRemoved
                ? 'Ads removed — thank you!'
                : 'One-time purchase to remove ads'),
            value: PurchaseService.adsRemoved,
            onChanged: PurchaseService.adsRemoved
                ? null
                : (value) => _purchaseRemoveAds(context),
          ),
          if (!PurchaseService.adsRemoved)
            ListTile(
              leading: const Icon(Icons.restore),
              title: const Text('Restore Purchases'),
              onTap: () async {
                await PurchaseService.restorePurchases();
                setState(() {});
              },
            ),
          const Divider(),

          // ── About ──
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('HabitLoop'),
            subtitle: Text('v1.0.0 — Free & Open Source'),
          ),
        ],
      ),
    );
  }

  Future<void> _purchaseRemoveAds(BuildContext context) async {
    final product = await PurchaseService.getProduct();
    if (product == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not available')),
        );
      }
      return;
    }
    final success = await PurchaseService.buyRemoveAds(product);
    if (!success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Purchase failed')),
      );
    }
    setState(() {});
  }

  Future<void> _exportData(BuildContext context) async {
    final habits = await DatabaseHelper.instance.getHabits();
    final exportData = <String, dynamic>{
      'habits': habits.map((h) => h.toMap()).toList(),
      'completions': <Map<String, dynamic>>[],
    };

    for (final habit in habits) {
      final completions =
          await DatabaseHelper.instance.getCompletionsForHabit(habit.id!);
      (exportData['completions'] as List)
          .addAll(completions.map((c) => c.toMap()));
    }

    final json = const JsonEncoder.withIndent('  ').convert(exportData);
    await Clipboard.setData(ClipboardData(text: json));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data copied to clipboard')),
      );
    }
  }

  Future<void> _importData(BuildContext context) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data?.text == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No data in clipboard')),
        );
      }
      return;
    }

    try {
      final json = jsonDecode(data!.text!) as Map<String, dynamic>;
      final habits =
          (json['habits'] as List).map((m) => Habit.fromMap(m)).toList();
      final completions = (json['completions'] as List)
          .map((m) => Completion.fromMap(m))
          .toList();

      for (final habit in habits) {
        await DatabaseHelper.instance.insertHabit(habit);
      }
      for (final completion in completions) {
        await DatabaseHelper.instance.insertCompletion(completion);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Imported ${habits.length} habits')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid data format')),
        );
      }
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
