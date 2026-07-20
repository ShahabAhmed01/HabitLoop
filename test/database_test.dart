import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:habitloop/models/habit.dart';
import 'package:habitloop/models/completion.dart';
import 'package:habitloop/database/database_helper.dart';

void main() {
  late DatabaseHelper dbHelper;

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  setUp(() async {
    dbHelper = DatabaseHelper.instance;
    final db = await dbHelper.database;
    await db.delete('completions');
    await db.delete('habits');
  });

  test('Insert and retrieve a habit', () async {
    final habit = Habit(name: 'Exercise', color: 0xFF00FF00);
    final id = await dbHelper.insertHabit(habit);

    expect(id, greaterThan(0));

    final habits = await dbHelper.getHabits();
    expect(habits.length, 1);
    expect(habits[0].name, 'Exercise');
  });

  test('Insert and delete a habit', () async {
    final habit = Habit(name: 'Read');
    final id = await dbHelper.insertHabit(habit);

    await dbHelper.deleteHabit(id);

    final habits = await dbHelper.getHabits();
    expect(habits.length, 0);
  });

  test('Insert and retrieve completions', () async {
    final habit = Habit(name: 'Meditate');
    final habitId = await dbHelper.insertHabit(habit);

    final today = DateTime.now();
    final completion = Completion(habitId: habitId, date: today);
    await dbHelper.insertCompletion(completion);

    final isCompleted = await dbHelper.isCompletedToday(habitId);
    expect(isCompleted, true);

    final dates = await dbHelper.getCompletionDates(habitId);
    expect(dates.length, 1);
  });

  test('Toggle completion off', () async {
    final habit = Habit(name: 'Journal');
    final habitId = await dbHelper.insertHabit(habit);

    final today = DateTime.now();
    final completion = Completion(habitId: habitId, date: today);
    await dbHelper.insertCompletion(completion);

    expect(await dbHelper.isCompletedToday(habitId), true);

    await dbHelper.deleteCompletion(habitId, today);

    expect(await dbHelper.isCompletedToday(habitId), false);
  });
}
