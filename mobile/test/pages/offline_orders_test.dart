import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/pages/offline_orders_page.dart';
import 'package:mobile/store/order_repository.dart';
import 'package:mobile/models/offline_order.dart';
import 'package:mockito/mockito.dart';

class MockOrderRepository extends Mock implements OrderRepository {
  @override
  Future<List<OfflineOrder>> getPendingOrders() async {
    return [];
  }
}

void main() {
  testWidgets('Offline Orders List displays title and empty state', (WidgetTester tester) async {
    final mockRepo = MockOrderRepository();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: OfflineOrdersPage(repository: mockRepo),
    ));

    // Verify that the title exists
    expect(find.text('Offline Orders'), findsOneWidget);

    // Initial state is loading
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the async _loadOrders to complete and UI to settle
    await tester.pumpAndSettle();
    
    // Expect the empty text since mock returns empty list
    expect(find.text('No offline orders'), findsOneWidget);
  });
}
