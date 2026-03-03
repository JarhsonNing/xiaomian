import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile/models/offline_order.dart';
import 'package:mobile/services/network_service.dart';
import 'package:mobile/store/order_repository.dart';

class SyncManager {
  final OrderRepository _repository;
  final NetworkService _networkService;
  final http.Client _httpClient;
  final String _apiUrl;
  
  bool _isSyncing = false;
  int _retryCount = 0;

  SyncManager({
    OrderRepository? repository,
    NetworkService? networkService,
    http.Client? httpClient,
    String? apiUrl,
  })  : _repository = repository ?? OrderRepository(),
        _networkService = networkService ?? NetworkService(),
        _httpClient = httpClient ?? http.Client(),
        _apiUrl = apiUrl ?? 'http://10.0.2.2:8080/v1/orders/bulk-sync' {
    _initNetworkListener();
  }

  void _initNetworkListener() {
    _networkService.onNetworkStatusChanged.listen((isConnected) {
      if (isConnected && !_isSyncing) {
        triggerSync();
      }
    });
  }

  Future<bool> triggerSync() async {
    if (_isSyncing) return false;
    
    final isConnected = await _networkService.isConnected;
    if (!isConnected) return false;

    _isSyncing = true;
    try {
      final pendingOrders = await _repository.getPendingOrders();
      if (pendingOrders.isEmpty) {
        _isSyncing = false;
        return true;
      }

      final payload = {
        "device_id": "device-uuid-123", // Mock device ID
        "orders": pendingOrders.map((o) {
          return {
            "client_uuid": o.tempId,
            "customer_id": o.customerId,
            "original_created_at": o.createdAt.toIso8601String(),
            "items": o.items.map((i) => {
              "product_id": i.productId,
              "quantity": i.quantity,
              "snapshot_price": i.snapshotPrice
            }).toList()
          };
        }).toList()
      };

      final response = await _httpClient.post(
        Uri.parse(_apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 201) {
        // Success, delete local orders per FR-008
        for (var order in pendingOrders) {
          await _repository.deleteOrder(order.tempId);
        }
        _retryCount = 0;
        _isSyncing = false;
        return true;
      } else {
        throw Exception('Server rejected sync: \u0024{response.statusCode}');
      }
    } catch (e) {
      _isSyncing = false;
      _handleExponentialBackoff();
      return false;
    }
  }

  void _handleExponentialBackoff() {
    _retryCount++;
    if (_retryCount > 5) return; // Max retries
    
    final delay = Duration(seconds: 2 * _retryCount);
    Future.delayed(delay, () => triggerSync());
  }
}
