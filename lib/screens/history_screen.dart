import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/habit.dart';
import '../utils/streak_utils.dart';

class HistoryScreen extends StatefulWidget {
  final Habit habit;

  const HistoryScreen({super.key, required this.habit});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Set<DateTime> _completedDates = {};
  StreakResult? _streaks;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dates = await DatabaseHelper.instance.getCompletionDates(widget.habit.id!);
    final streaks = await StreakUtils.calculate(widget.habit.id!);
    setState(() {
      _completedDates = dates.map((d) => DateTime(d.year, d.month, d.day)).toSet();
      _streaks = streaks;
    });
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.habit.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          if (_streaks != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StreakCard(
                    label: 'Current Streak',
                    value: '${_streaks!.current}',
                    icon: Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                  _StreakCard(
                    label: 'Best Streak',
                    value: '${_streaks!.best}',
                    icon: Icons.emoji_events,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last 12 weeks',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _buildContributionGrid(today),
          ),
        ],
      ),
    );
  }

  Widget _buildContributionGrid(DateTime today) {
    final weeks = 12;
    final startDay = today.subtract(Duration(days: (weeks * 7) - 1 + today.weekday % 7));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: List.generate(weeks, (week) {
              return Expanded(
                child: Column(
                  children: List.generate(7, (day) {
                    final date = startDay.add(Duration(days: week * 7 + day));
                    if (date.isAfter(today)) return const SizedBox(height: 14, width: 14);
                    final isCompleted = _completedDates.contains(date);
                    return Padding(
                      padding: const EdgeInsets.all(1),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Color(widget.habit.color)
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StreakCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
