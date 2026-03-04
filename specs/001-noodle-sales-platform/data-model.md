# Data Model: Noodle Shop Sales Platform

## Entities

### `Product`
Master record for saleable items.

| Field | Type | Description |
|-------|------|-------------|
| `id` | SERIAL | Primary key. |
| `name` | STRING | Full name. |
| `alias` | STRING | Short common name. |
| `default_price` | DECIMAL | Base price if no mapping exists. |
| `pinyin_abbreviation` | STRING | e.g., "NRM" (Indexed). |
| `cost_price` | DECIMAL | Internal cost for margin analysis. |

### `Customer`
Standard buyers.

| Field | Type | Description |
|-------|------|-------------|
| `id` | SERIAL | Primary key. |
| `name` | STRING | Customer name. |
| `phone` | STRING | Contact info. |
| `is_active` | BOOLEAN | Soft delete toggle. |

### `CustomerProductPrice`
Overrides default price for specific customers.

| Field | Type | Description |
|-------|------|-------------|
| `customer_id` | INT | FK to Customer. |
| `product_id` | INT | FK to Product. |
| `custom_price` | DECIMAL | The special price for this customer. |

### `Order`
Transaction summary.

| Field | Type | Description |
|-------|------|-------------|
| `id` | SERIAL | Primary key. |
| `customer_id` | INT | FK to Customer. |
| `total_amount` | DECIMAL | Sum of all order items. |
| `created_at` | TIMESTAMP | ISO8601. |
| `print_count` | INT | Track receipt reprints. |

### `OrderItem`
Specific products within an order.

| Field | Type | Description |
|-------|------|-------------|
| `id` | SERIAL | Primary key. |
| `order_id` | INT | FK to Order. |
| `product_id` | INT | FK to Product. |
| `snapshot_name` | STRING | Name at time of sale (Traceability). |
| `snapshot_price` | DECIMAL | Price at time of sale (Traceability). |
| `quantity` | DECIMAL | Units sold. |

## State Transitions
1. **PRODUCT_CONFIG**: Admin sets prices.
2. **ORDER_INITIALIZED**: Worker selects customer.
3. **PRICE_OVERRIDE**: Worker manually adjusts price during order (updates `CustomerProductPrice` permanently).
4. **ORDER_FINALIZED**: Snapshot taken, Order saved, Receipt printed.
