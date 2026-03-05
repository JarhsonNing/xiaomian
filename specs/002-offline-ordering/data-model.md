# Data Model: Offline Ordering Support

## Entities

### `OfflineOrder` (Mobile/Local)
Represents an order created on the device while offline.

| Field | Type | Description |
|-------|------|-------------|
| `temp_id` | UUID | Unique client-side identifier. |
| `customer_id` | INT | Linked customer ID. |
| `total_amount` | DECIMAL | Total sum at creation. |
| `created_at` | TIMESTAMP | Exact time order was placed (Local). |
| `sync_status` | STRING | Enum: `PENDING`, `SYNCING`, `FAILED`. |
| `items` | JSON/List | Snapshot of items (see `OfflineOrderItem`). |

### `Order` (Server/Global)
The canonical record on the backend.

| Field | Type | Description |
|-------|------|-------------|
| `id` | SERIAL | Primary key. |
| `client_uuid` | UUID | Tracks origin from mobile (Traceability). |
| `customer_id` | INT | Customer reference. |
| `total_price` | DECIMAL | Price at transaction time. |
| `is_offline_origin`| BOOLEAN | Flag for audit/reporting. |
| `original_created_at` | TIMESTAMP | The actual offline creation time. |
| `synced_at` | TIMESTAMP | Time of upload. |

### `OfflineOrderItem` (Embedded/Reference)
Specific items within an order.

| Field | Type | Description |
|-------|------|-------------|
| `product_id` | INT | Product reference. |
| `quantity` | DECIMAL | Amount ordered. |
| `snapshot_price` | DECIMAL | Price locked at transaction (Traceability). |
| `pinyin_shortcut` | STRING | Search term used (for debugging). |

## State Transitions
1. **DRAFT**: Items added to cart.
2. **LOCAL_PERSISTED**: User confirms, saved to SQLite. `sync_status` = `PENDING`.
3. **SYNC_IN_PROGRESS**: Background service detects network and starts POSTing.
4. **SYNCED**: Server returns 201 Created. Local record is DELETED (per clarification).
5. **SYNC_FAILED**: Server returns error or network drops. Retries with backoff.
