import 'package:mobile/models/offline_order.dart';
import 'package:mobile/store/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class OrderRepository {
  final DatabaseHelper _dbHelper;

  OrderRepository({DatabaseHelper? dbHelper})
      : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  Future<void> saveOrder(OfflineOrder order) async {
    final db = await _dbHelper.database;
    await db.insert('offline_orders', order.toMap());
  }

  Future<List<OfflineOrder>> getPendingOrders() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'offline_orders',
      where: 'sync_status = ?',
      whereArgs: ['PENDING'],
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => OfflineOrder.fromMap(map)).toList();
  }

  Future<int> getPendingOrdersCount() async {
    final db = await _dbHelper.database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM offline_orders WHERE sync_status = "PENDING"');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> deleteOrder(String tempId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'offline_orders',
      where: 'temp_id = ?',
      whereArgs: [tempId],
    );
  }
}
