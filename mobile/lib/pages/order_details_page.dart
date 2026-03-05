import 'package:flutter/material.dart';
import 'package:mobile/models/offline_order.dart';

class OrderDetailsPage extends StatelessWidget {
  final OfflineOrder order;

  const OrderDetailsPage({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text('Total: \u0024{order.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 16),
          Text('Original Creation: \u0024{order.createdAt.toLocal()}'),
          if (order.syncAt != null)
            Text('Synced At: \u0024{order.syncAt!.toLocal()}'),
          const Divider(),
          const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
          ...order.items.map((item) => ListTile(
            title: Text('Product ID: \u0024{item.productId}'),
            subtitle: Text('Qty: \u0024{item.quantity} | Snapshot Price: \u0024\u0024{item.snapshotPrice}'),
          )),
        ],
      ),
    );
  }
}
