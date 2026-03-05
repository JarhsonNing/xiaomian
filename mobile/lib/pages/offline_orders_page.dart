import 'package:flutter/material.dart';
import 'package:mobile/models/offline_order.dart';
import 'package:mobile/store/order_repository.dart';
import 'package:mobile/components/status_badge.dart';

class OfflineOrdersPage extends StatefulWidget {
  final OrderRepository? repository;

  const OfflineOrdersPage({super.key, this.repository});

  @override
  State<OfflineOrdersPage> createState() => _OfflineOrdersPageState();
}

class _OfflineOrdersPageState extends State<OfflineOrdersPage> {
  late final OrderRepository _repository;
  List<OfflineOrder> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _repository = widget.repository ?? OrderRepository();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final orders = await _repository.getPendingOrders();
    if (mounted) {
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    }
  }

  Future<void> _syncNow() async {
    // Basic UI placeholder for sync trigger. Real implementation would hook into SyncManager.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Syncing orders...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Orders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _syncNow,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _orders.isEmpty
              ? const Center(child: Text('No offline orders'))
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return ListTile(
                      title: Text('Order: \u0024{order.totalAmount.toStringAsFixed(2)}'),
                      subtitle: Text(order.createdAt.toString()),
                      trailing: StatusBadge(status: order.syncStatus),
                    );
                  },
                ),
    );
  }
}
