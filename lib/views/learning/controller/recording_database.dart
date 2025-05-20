import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class RecordingDatabase {
  static final RecordingDatabase instance = RecordingDatabase._init();
  static Database? _database;

  RecordingDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recordings.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recordings (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        voicePath TEXT,
        backgroundPosition INTEGER,
        duration INTEGER,
        createdAt TEXT
      )
    ''');
  }

  Future<int> createRecording(Recording recording) async {
    final db = await instance.database;
    return await db.insert('recordings', recording.toMap());
  }

  Future<List<Recording>> readAllRecordings() async {
    final db = await instance.database;
    final result = await db.query('recordings', orderBy: 'createdAt DESC');
    return result.map((json) => Recording.fromMap(json)).toList();
  }

  Future<int> deleteRecording(int id) async {
    final db = await instance.database;
    return await db.delete(
      'recordings',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

class Recording {
  final int? id;
  final String title;
  final String voicePath;
  final Duration backgroundPosition;
  final Duration duration;
  final DateTime createdAt;

  Recording({
    this.id,
    required this.title,
    required this.voicePath,
    required this.backgroundPosition,
    required this.duration,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'voicePath': voicePath,
      'backgroundPosition': backgroundPosition.inMilliseconds,
      'duration': duration.inMilliseconds,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Recording.fromMap(Map<String, dynamic> map) {
    return Recording(
      id: map['id'],
      title: map['title'],
      voicePath: map['voicePath'],
      backgroundPosition: Duration(milliseconds: map['backgroundPosition']),
      duration: Duration(milliseconds: map['duration']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}