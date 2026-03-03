# API Contract: Offline Ordering Support

## Endpoint: Bulk Sync Orders
`POST /v1/orders/bulk-sync`

Submit locally stored offline orders for server-side persistence.

### Request Body (JSON)
```json
{
  "device_id": "UUID-of-mobile-device",
  "orders": [
    {
      "client_uuid": "550e8400-e29b-41d4-a716-446655440000",
      "customer_id": 101,
      "original_created_at": "2026-03-03T08:30:00Z",
      "items": [
        {
          "product_id": 1,
          "quantity": 2.0,
          "snapshot_price": 12.50
        }
      ]
    }
  ]
}
```

### Success Response (201 Created)
```json
{
  "sync_id": "sync-record-uuid",
  "processed_count": 1,
  "failed_orders": []
}
```

### Error Response (400 Bad Request)
```json
{
  "error": "INVALID_SNAPSHOT",
  "message": "Missing product ID in one or more orders",
  "failed_client_uuids": ["550e8400-e29b-41d4-a716-446655440000"]
}
```

---

## Endpoint: Get Customer Prices (Real-time Fetch)
`GET /v1/customers/{id}/prices`

Fetch current product-customer price mappings.

### Response (200 OK)
```json
{
  "customer_id": 101,
  "last_updated": "2026-03-03T08:00:00Z",
  "prices": [
    {
      "product_id": 1,
      "price": 12.50,
      "pinyin_shortcut": "NRM"
    }
  ]
}
```
