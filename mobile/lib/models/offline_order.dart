import 'dart:convert';

class OfflineOrder {
  final String tempId;
  final int customerId;
  final double totalAmount;
  final DateTime createdAt;
  final String syncStatus;
  final List<OfflineOrderItem> items;
  final DateTime? syncAt;

  OfflineOrder({
    required this.tempId,
    required this.customerId,
    required this.totalAmount,
    required this.createdAt,
    required this.syncStatus,
    required this.items,
    this.syncAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'temp_id': tempId,
      'customer_id': customerId,
      'total_amount': totalAmount,
      'created_at': createdAt.toIso8601String(),
      'sync_status': syncStatus,
      'items': jsonEncode(items.map((item) => item.toMap()).toList()),
      'sync_at': syncAt?.toIso8601String(),
    };
  }

  factory OfflineOrder.fromMap(Map<String, dynamic> map) {
    return OfflineOrder(
      tempId: map['temp_id'],
      customerId: map['customer_id'],
      totalAmount: map['total_amount'],
      createdAt: DateTime.parse(map['created_at']),
      syncStatus: map['sync_status'],
      items: (jsonDecode(map['items']) as List)
          .map((itemMap) => OfflineOrderItem.fromMap(itemMap))
          .toList(),
      syncAt: map['sync_at'] != null ? DateTime.parse(map['sync_at']) : null,
    );
  }
}

class OfflineOrderItem {
  final int productId;
  final double quantity;
  final double snapshotPrice;

  OfflineOrderItem({
    required this.productId,
    required this.quantity,
    required this.snapshotPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'snapshot_price': snapshotPrice,
    };
  }

  factory OfflineOrderItem.fromMap(Map<String, dynamic> map) {
    return OfflineOrderItem(
      productId: map['product_id'],
      quantity: map['quantity'],
      snapshotPrice: map['snapshot_price'],
    );
  }
}
