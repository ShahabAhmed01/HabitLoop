import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../utils/streak_utils.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  int _totalHabits = 0;
  int _completedToday = 0;
  int _longestCurrentStreak = 0;
  int _longestBestStreak = 0;
  int _totalCompletions = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final habits = await DatabaseHelper.instance.getHabits();
    int completedToday = 0;
    int longestCurrent = 0;
    int longestBest = 0;
    int totalCompletions = 0;

    for (final habit in habits) {
      final isCompleted = await DatabaseHelper.instance.isCompletedToday(habit.id!);
      if (isCompleted) completedToday++;

      final streaks = await StreakUtils.calculate(habit.id!);
      if (streaks.current > longestCurrent) longestCurrent = streaks.current;
      if (streaks.best > longestBest) longestBest = streaks.best;

      final completions = await DatabaseHelper.instance.getCompletionsForHabit(habit.id!);
      totalCompletions += completions.length;
    }

    setState(() {
      _totalHabits = habits.length;
      _completedToday = completedToday;
      _longestCurrentStreak = longestCurrent;
      _longestBestStreak = longestBest;
      _totalCompletions = totalCompletions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _totalHabits == 0
          ? const Center(
              child: Text('Add some habits to see stats.'),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _StatCard(
                  title: 'Today',
                  subtitle: '$_completedToday of $_totalHabits completed',
                  icon: Icons.today,
                  color: Colors.green,
                ),
                _StatCard(
                  title: 'Longest Current Streak',
                  subtitle: '$_longestCurrentStreak days',
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                ),
                _StatCard(
                  title: 'All-Time Best Streak',
                  subtitle: '$_longestBestStreak days',
                  icon: Icons.emoji_events,
                  color: Colors.amber,
                ),
                _StatCard(
                  title: 'Total Completions',
                  subtitle: '$_totalCompletions check-offs',
                  icon: Icons.check_circle,
                  color: Colors.blue,
                ),
              ],
            ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
