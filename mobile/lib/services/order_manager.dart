import 'package:mobile/models/offline_order.dart';
import 'package:mobile/services/network_service.dart';
import 'package:mobile/store/order_repository.dart';

class OrderManager {
  final OrderRepository _repository;
  final NetworkService _networkService;
  static const int MAX_OFFLINE_ORDERS = 500;

  OrderManager({OrderRepository? repository, NetworkService? networkService})
      : _repository = repository ?? OrderRepository(),
        _networkService = networkService ?? NetworkService();

  Future<bool> get isOfflineMode async {
    return !(await _networkService.isConnected);
  }

  Future<void> placeOrder(OfflineOrder order) async {
    final isOffline = await isOfflineMode;

    if (isOffline) {
      await _saveOffline(order);
    } else {
      // In a real app, try API first, fallback to offline on failure
      // For this MVP, we focus on the offline path
      await _saveOffline(order);
    }
  }

  Future<void> _saveOffline(OfflineOrder order) async {
    final count = await _repository.getPendingOrdersCount();
    if (count >= MAX_OFFLINE_ORDERS) {
      throw StorageFullException('Local storage is full. Please connect to the internet to sync pending orders.');
    }
    await _repository.saveOrder(order);
  }
}

class StorageFullException implements Exception {
  final String message;
  StorageFullException(this.message);
  @override
  String toString() => message;
}
