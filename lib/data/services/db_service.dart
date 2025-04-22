import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/pomodoro_session.dart';
import '../models/study_topic.dart';

class DBService {
  static final DBService _instance = DBService._internal();
  static Database? _database;

  factory DBService() => _instance;

  DBService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'pomodoro_timer.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create topics table
    await db.execute('''
      CREATE TABLE topics(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        color INTEGER NOT NULL
      )
    ''');

    // Create sessions table
    await db.execute('''
      CREATE TABLE sessions(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        topic_id INTEGER,
        start_time INTEGER NOT NULL,
        end_time INTEGER NOT NULL,
        duration INTEGER NOT NULL,
        is_completed INTEGER NOT NULL,
        FOREIGN KEY (topic_id) REFERENCES topics(id)
      )
    ''');
  }

  // Topics CRUD operations
  Future<int> insertTopic(StudyTopic topic) async {
    final db = await database;
    return await db.insert('topics', topic.toMap());
  }

  Future<List<StudyTopic>> getTopics() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('topics');
    return List.generate(maps.length, (i) => StudyTopic.fromMap(maps[i]));
  }

  Future<int> updateTopic(StudyTopic topic) async {
    final db = await database;
    return await db.update(
      'topics',
      topic.toMap(),
      where: 'id = ?',
      whereArgs: [topic.id],
    );
  }

  Future<int> deleteTopic(int id) async {
    final db = await database;
    return await db.delete(
      'topics',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Sessions CRUD operations
  Future<int> insertSession(PomodoroSession session) async {
    final db = await database;
    return await db.insert('sessions', session.toMap());
  }

  Future<List<PomodoroSession>> getSessions() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sessions');
    return List.generate(maps.length, (i) => PomodoroSession.fromMap(maps[i]));
  }

  Future<List<PomodoroSession>> getSessionsByTopic(int topicId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      where: 'topic_id = ?',
      whereArgs: [topicId],
    );
    return List.generate(maps.length, (i) => PomodoroSession.fromMap(maps[i]));
  }

  Future<List<PomodoroSession>> getSessionsByDateRange(DateTime start, DateTime end) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'sessions',
      where: 'start_time >= ? AND start_time <= ?',
      whereArgs: [start.millisecondsSinceEpoch, end.millisecondsSinceEpoch],
    );
    return List.generate(maps.length, (i) => PomodoroSession.fromMap(maps[i]));
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final db = await database;
    final totalSessions = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM sessions')
    ) ?? 0;
    final completedSessions = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM sessions WHERE is_completed = 1')
    ) ?? 0;
    final totalDuration = Sqflite.firstIntValue(
      await db.rawQuery('SELECT SUM(duration) FROM sessions')
    ) ?? 0;

    return {
      'totalSessions': totalSessions,
      'completedSessions': completedSessions,
      'totalDuration': totalDuration,
    };
  }
}