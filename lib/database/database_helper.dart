import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit.dart';
import '../models/completion.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('habitloop.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        icon TEXT,
        color INTEGER NOT NULL DEFAULT ${0xFF6750A4},
        frequency TEXT NOT NULL DEFAULT 'daily',
        created_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE completions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id INTEGER NOT NULL,
        date TEXT NOT NULL,
        FOREIGN KEY (habit_id) REFERENCES habits (id) ON DELETE CASCADE,
        UNIQUE(habit_id, date)
      )
    ''');
  }

  String _dateOnly(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<int> insertHabit(Habit habit) async {
    final db = await database;
    return await db.insert('habits', habit.toMap());
  }

  Future<List<Habit>> getHabits() async {
    final db = await database;
    final maps = await db.query('habits', orderBy: 'created_at DESC');
    return maps.map((map) => Habit.fromMap(map)).toList();
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    return await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await database;
    return await db.delete('habits', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertCompletion(Completion completion) async {
    final db = await database;
    final map = completion.toMap();
    map['date'] = _dateOnly(completion.date);
    return await db.insert('completions', map);
  }

  Future<int> deleteCompletion(int habitId, DateTime date) async {
    final db = await database;
    final dateStr = _dateOnly(date);
    return await db.delete(
      'completions',
      where: 'habit_id = ? AND date = ?',
      whereArgs: [habitId, dateStr],
    );
  }

  Future<List<Completion>> getCompletionsForHabit(int habitId) async {
    final db = await database;
    final maps = await db.query(
      'completions',
      where: 'habit_id = ?',
      whereArgs: [habitId],
      orderBy: 'date DESC',
    );
    return maps.map((map) => Completion.fromMap(map)).toList();
  }

  Future<bool> isCompletedToday(int habitId) async {
    final db = await database;
    final todayStr = _dateOnly(DateTime.now());
    final result = await db.query(
      'completions',
      where: 'habit_id = ? AND date = ?',
      whereArgs: [habitId, todayStr],
    );
    return result.isNotEmpty;
  }

  Future<List<DateTime>> getCompletionDates(int habitId) async {
    final db = await database;
    final maps = await db.query(
      'completions',
      where: 'habit_id = ?',
      whereArgs: [habitId],
      orderBy: 'date ASC',
    );
    return maps.map((map) => DateTime.parse(map['date'] as String)).toList();
  }
}
