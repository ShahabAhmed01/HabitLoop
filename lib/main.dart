import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/home_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/settings_screen.dart';
import 'services/ad_service.dart';
import 'services/purchase_service.dart';
import 'services/notification_service.dart';
import 'utils/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  await AdService.init();
  await PurchaseService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitLoop',
      debugShowCheckedModeBanner: false,
      home: const ThemeProvider(),
    );
  }
}

class ThemeProvider extends StatefulWidget {
  const ThemeProvider({super.key});

  @override
  State<ThemeProvider> createState() => _ThemeProviderState();
}

class _ThemeProviderState extends State<ThemeProvider> {
  String _themeName = 'Forest';
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('theme_name');
    final mode = prefs.getString('dark_mode');
    setState(() {
      if (name != null) _themeName = name;
      _themeMode = _parseThemeMode(mode ?? 'system');
    });
  }

  ThemeMode _parseThemeMode(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeModeToString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }

  void _onThemeChanged(String name) async {
    setState(() => _themeName = name);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme_name', name);
  }

  void _onDarkModeChanged(ThemeMode mode) async {
    setState(() => _themeMode = mode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dark_mode', _themeModeToString(mode));
  }

  @override
  Widget build(BuildContext context) {
    // Build a MaterialApp that provides the theme to the inner ThemeProvider
    return MaterialApp(
      title: 'HabitLoop',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.getTheme(_themeName, Brightness.light),
      darkTheme: AppThemes.getTheme(_themeName, Brightness.dark),
      themeMode: _themeMode,
      home: MainShell(
        themeName: _themeName,
        themeMode: _themeMode,
        onThemeChanged: _onThemeChanged,
        onDarkModeChanged: _onDarkModeChanged,
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final String themeName;
  final ThemeMode themeMode;
  final ValueChanged<String> onThemeChanged;
  final ValueChanged<ThemeMode> onDarkModeChanged;

  const MainShell({
    super.key,
    required this.themeName,
    required this.themeMode,
    required this.onThemeChanged,
    required this.onDarkModeChanged,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const HomeScreen(),
      const StatsScreen(),
      SettingsScreen(
        themeName: widget.themeName,
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
        onDarkModeChanged: widget.onDarkModeChanged,
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
