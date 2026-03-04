# API Contract: Noodle Shop Sales Platform

## Endpoint: Create Order
`POST /v1/orders`

Processes a new sale and updates customer-specific price mappings.

### Request Body (JSON)
```json
{
  "customer_id": 101,
  "items": [
    {
      "product_id": 1,
      "quantity": 2.0,
      "final_price": 12.50
    }
  ]
}
```

### Success Response (201 Created)
Returns the created order ID and status.

---

## Endpoint: Get Customer Product Prices
`GET /v1/customers/{id}/prices`

Fetch all products with the specific prices for a given customer.

### Response (200 OK)
```json
{
  "customer_id": 101,
  "prices": [
    {
      "product_id": 1,
      "name": "牛肉面",
      "pinyin": "NRM",
      "current_price": 12.50
    }
  ]
}
```

---

## Endpoint: Product Management
`GET /v1/products` | `POST /v1/products` | `PATCH /v1/products/{id}`

Standard CRUD for product master data.

---

## Endpoint: Customer Management
`GET /v1/customers` | `POST /v1/customers`

Standard CRUD for customer profiles.
