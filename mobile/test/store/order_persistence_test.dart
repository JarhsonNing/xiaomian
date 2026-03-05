import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:mobile/store/db_helper.dart';
import 'package:mobile/models/offline_order.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('OfflineOrder Persistence', () {
    test('should insert and retrieve an OfflineOrder', () async {
      final dbHelper = DatabaseHelper.instance;
      final db = await dbHelper.database;

      // Clean up before test
      await db.delete('offline_orders');

      final order = OfflineOrder(
        tempId: 'test-uuid-1234',
        customerId: 1,
        totalAmount: 15.50,
        createdAt: DateTime.parse('2026-03-03T10:00:00Z'),
        syncStatus: 'PENDING',
        items: [
          OfflineOrderItem(productId: 101, quantity: 2, snapshotPrice: 7.75)
        ],
      );

      // Insert
      await db.insert('offline_orders', order.toMap());

      // Retrieve
      final List<Map<String, dynamic>> maps = await db.query('offline_orders');

      expect(maps.length, 1);
      final retrievedOrder = OfflineOrder.fromMap(maps.first);

      expect(retrievedOrder.tempId, 'test-uuid-1234');
      expect(retrievedOrder.customerId, 1);
      expect(retrievedOrder.totalAmount, 15.50);
      expect(retrievedOrder.items.length, 1);
      expect(retrievedOrder.items.first.productId, 101);
    });
  });
}
