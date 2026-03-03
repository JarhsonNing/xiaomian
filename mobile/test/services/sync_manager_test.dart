import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/models/offline_order.dart';
import 'package:mobile/store/order_repository.dart';
import 'package:mobile/services/network_service.dart';
import 'package:mobile/services/sync_manager.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class FakeOrderRepository extends Fake implements OrderRepository {
  final OfflineOrder fakeOrder;
  int deleteCalled = 0;

  FakeOrderRepository(this.fakeOrder);

  @override
  Future<List<OfflineOrder>> getPendingOrders() async => [fakeOrder];

  @override
  Future<void> deleteOrder(String id) async {
    deleteCalled++;
  }
}

class FakeNetworkService extends Fake implements NetworkService {
  @override
  Stream<bool> get onNetworkStatusChanged => const Stream.empty();
  
  @override
  Future<bool> get isConnected => Future.value(true);
}

class FakeHttpClient extends Fake implements http.Client {
  @override
  Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) async {
    return http.Response('{"sync_id": "test", "processed_count": 1}', 201);
  }
}

void main() {
  group('SyncManager', () {
    test('should sync and delete local orders when network is available', () async {
      final fakeOrder = OfflineOrder(
        tempId: 'test-uuid',
        customerId: 1,
        totalAmount: 10,
        createdAt: DateTime.now(),
        syncStatus: 'PENDING',
        items: [],
      );

      final fakeRepo = FakeOrderRepository(fakeOrder);
      final fakeNetwork = FakeNetworkService();
      final fakeHttp = FakeHttpClient();

      final syncManager = SyncManager(
        repository: fakeRepo,
        networkService: fakeNetwork,
        httpClient: fakeHttp,
        apiUrl: 'http://test.com/v1/orders/bulk-sync',
      );

      final success = await syncManager.triggerSync();

      expect(success, isTrue);
      expect(fakeRepo.deleteCalled, 1);
    });
  });
}
