import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:habitloop/models/habit.dart';
import 'package:habitloop/models/completion.dart';
import 'package:habitloop/database/database_helper.dart';
import 'package:habitloop/utils/streak_utils.dart';

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

  DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _daysAgo(int days) => _today().subtract(Duration(days: days));

  test('Empty completions = 0 streaks', () async {
    final habit = Habit(name: 'Test');
    final id = await dbHelper.insertHabit(habit);
    final result = await StreakUtils.calculate(id);
    expect(result.current, 0);
    expect(result.best, 0);
  });

  test('Single completion today = current 1, best 1', () async {
    final habit = Habit(name: 'Test');
    final id = await dbHelper.insertHabit(habit);
    await dbHelper.insertCompletion(Completion(habitId: id, date: _today()));
    final result = await StreakUtils.calculate(id);
    expect(result.current, 1);
    expect(result.best, 1);
  });

  test('Consecutive 3 days including today = current 3, best 3', () async {
    final habit = Habit(name: 'Test');
    final id = await dbHelper.insertHabit(habit);
    await dbHelper.insertCompletion(Completion(habitId: id, date: _daysAgo(2)));
    await dbHelper.insertCompletion(Completion(habitId: id, date: _daysAgo(1)));
    await dbHelper.insertCompletion(Completion(habitId: id, date: _today()));
    final result = await StreakUtils.calculate(id);
    expect(result.current, 3);
    expect(result.best, 3);
  });

  test('Gap breaks current but best preserved', () async {
    final habit = Habit(name: 'Test');
    final id = await dbHelper.insertHabit(habit);
    // Old streak: 3 days
    await dbHelper.insertCompletion(Completion(habitId: id, date: _daysAgo(10)));
    await dbHelper.insertCompletion(Completion(habitId: id, date: _daysAgo(9)));
    await dbHelper.insertCompletion(Completion(habitId: id, date: _daysAgo(8)));
    // Gap, then today only
    await dbHelper.insertCompletion(Completion(habitId: id, date: _today()));
    final result = await StreakUtils.calculate(id);
    expect(result.current, 1);
    expect(result.best, 3);
  });

  test('Completion yesterday only = current 1', () async {
    final habit = Habit(name: 'Test');
    final id = await dbHelper.insertHabit(habit);
    await dbHelper.insertCompletion(Completion(habitId: id, date: _daysAgo(1)));
    final result = await StreakUtils.calculate(id);
    expect(result.current, 1);
    expect(result.best, 1);
  });

  test('Completion 2 days ago = current 0 (streak broken)', () async {
    final habit = Habit(name: 'Test');
    final id = await dbHelper.insertHabit(habit);
    await dbHelper.insertCompletion(Completion(habitId: id, date: _daysAgo(2)));
    final result = await StreakUtils.calculate(id);
    expect(result.current, 0);
    expect(result.best, 1);
  });

  test('7-day streak', () async {
    final habit = Habit(name: 'Test');
    final id = await dbHelper.insertHabit(habit);
    for (int i = 6; i >= 0; i--) {
      await dbHelper.insertCompletion(Completion(habitId: id, date: _daysAgo(i)));
    }
    final result = await StreakUtils.calculate(id);
    expect(result.current, 7);
    expect(result.best, 7);
  });
}
