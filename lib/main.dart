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
      theme: AppThemes.forestLight,
      darkTheme: AppThemes.midnightDark,
      themeMode: ThemeMode.system,
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
  ThemeEntry _currentTheme = ThemeEntry.all[0]; // Forest (light)

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('theme_name');
    if (name != null) {
      setState(() => _currentTheme = ThemeEntry.byName(name));
    }
  }

  void _onThemeChanged(ThemeEntry entry) {
    setState(() => _currentTheme = entry);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HabitLoop',
      theme: _currentTheme.theme,
      debugShowCheckedModeBanner: false,
      home: MainShell(
        onThemeChanged: _onThemeChanged,
        currentTheme: _currentTheme,
      ),
    );
  }
}

class MainShell extends StatefulWidget {
  final ValueChanged<ThemeEntry> onThemeChanged;
  final ThemeEntry currentTheme;

  const MainShell({
    super.key,
    required this.onThemeChanged,
    required this.currentTheme,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _screens = [
    const HomeScreen(),
    const StatsScreen(),
    SettingsScreen(
      currentTheme: widget.currentTheme,
      onThemeChanged: widget.onThemeChanged,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
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
