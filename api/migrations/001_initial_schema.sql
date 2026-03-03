-- Create Orders table
CREATE TABLE IF NOT EXISTS orders (
    id SERIAL PRIMARY KEY,
    client_uuid UUID NOT NULL,
    customer_id INTEGER NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    is_offline_origin BOOLEAN DEFAULT FALSE,
    original_created_at TIMESTAMP NOT NULL,
    synced_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Order Items table
CREATE TABLE IF NOT EXISTS order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL,
    snapshot_price DECIMAL(10, 2) NOT NULL
);
