import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/habit.dart';
import '../models/completion.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Habit> _habits = [];
  Map<int, bool> _completedToday = {};

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final habits = await DatabaseHelper.instance.getHabits();
    final completed = <int, bool>{};
    for (final habit in habits) {
      completed[habit.id!] = await DatabaseHelper.instance.isCompletedToday(habit.id!);
    }
    setState(() {
      _habits = habits;
      _completedToday = completed;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HabitLoop'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _habits.isEmpty
          ? const Center(
              child: Text(
                'No habits yet.\nTap + to add your first habit.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: _habits.length,
              itemBuilder: (context, index) {
                final habit = _habits[index];
                final isCompleted = _completedToday[habit.id] ?? false;
                return ListTile(
                  leading: Icon(
                    isCompleted ? Icons.check_circle : Icons.circle_outlined,
                    color: isCompleted ? Colors.green : null,
                    size: 32,
                  ),
                  title: Text(
                    habit.name,
                    style: TextStyle(
                      decoration: isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: Text(habit.frequency),
                  onTap: () => _toggleCompletion(habit),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Placeholder for add habit screen
        },
        tooltip: 'Add Habit',
        child: const Icon(Icons.add),
      ),
    );
  }
}
