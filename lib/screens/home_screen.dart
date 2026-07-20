import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/habit.dart';
import '../models/completion.dart';
import '../utils/streak_utils.dart';
import 'add_edit_habit_screen.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];
  Map<int, bool> _completedToday = {};
  Map<int, StreakResult> _streaks = {};

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await DatabaseHelper.instance.getHabits();
    final completed = <int, bool>{};
    final streaks = <int, StreakResult>{};
    for (final habit in habits) {
      completed[habit.id!] = await DatabaseHelper.instance.isCompletedToday(habit.id!);
      streaks[habit.id!] = await StreakUtils.calculate(habit.id!);
    }
    setState(() {
      _habits = habits;
      _completedToday = completed;
      _streaks = streaks;
    });
  }

  Future<void> _toggleCompletion(Habit habit) async {
    final isCompleted = _completedToday[habit.id] ?? false;
    if (isCompleted) {
      await DatabaseHelper.instance.deleteCompletion(habit.id!, DateTime.now());
    } else {
      await DatabaseHelper.instance.insertCompletion(
        Completion(habitId: habit.id!, date: DateTime.now()),
      );
    }
    await _loadHabits();
  }

  Future<void> _deleteHabit(Habit habit) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: Text('Delete "${habit.name}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await DatabaseHelper.instance.deleteHabit(habit.id!);
      await _loadHabits();
    }
  }

  static const Map<String, IconData> _iconMap = {
    'fitness': Icons.fitness_center,
    'book': Icons.menu_book,
    'water': Icons.water_drop,
    'sleep': Icons.bedtime,
    'meditate': Icons.self_improvement,
    'run': Icons.directions_run,
    'code': Icons.code,
    'music': Icons.music_note,
    'food': Icons.restaurant,
    'health': Icons.favorite,
    'work': Icons.work,
    'study': Icons.school,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitLoop'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _habits.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.track_changes, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No habits yet',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap the + button to add your first habit and start tracking.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                final isCompleted = _completedToday[habit.id] ?? false;
                final streak = _streaks[habit.id];
                final habitIcon = habit.icon != null ? _iconMap[habit.icon] : Icons.circle;
                return Dismissible(
                  key: Key('habit_${habit.id}'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    await _deleteHabit(habit);
                    return false;
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color(habit.color).withValues(alpha: 0.2),
                      child: Icon(habitIcon, color: Color(habit.color), size: 20),
                    ),
                    title: Text(
                      habit.name,
                      style: TextStyle(
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                        color: isCompleted ? Colors.grey : null,
                      ),
                    ),
                    subtitle: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HistoryScreen(habit: habit),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text(habit.frequency),
                          if (streak != null && streak.current > 0) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.local_fire_department, size: 14, color: Colors.orange),
                            Text(' ${streak.current}', style: const TextStyle(color: Colors.orange)),
                          ],
                        ],
                      ),
                    ),
                    trailing: Icon(
                      isCompleted ? Icons.check_circle : Icons.circle_outlined,
                      color: isCompleted ? Colors.green : Colors.grey,
                      size: 28,
                    ),
                    onTap: () => _toggleCompletion(habit),
                    onLongPress: () async {
                      final result = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddEditHabitScreen(habit: habit),
                        ),
                      );
                      if (result == true) await _loadHabits();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const AddEditHabitScreen()),
          );
          if (result == true) await _loadHabits();
        },
        tooltip: 'Add Habit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
