import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('offline_orders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const integerType = 'INTEGER NOT NULL';
    const textType = 'TEXT NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
CREATE TABLE offline_orders (
  temp_id $idType,
  customer_id $integerType,
  total_amount $realType,
  created_at $textType,
  sync_status $textType,
  items $textType,
  sync_at TEXT
  )
''');

    await db.execute('CREATE INDEX idx_sync_status ON offline_orders(sync_status);');
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
