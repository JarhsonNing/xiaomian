-- Create Product table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    alias VARCHAR(255),
    default_price DECIMAL(10, 2) NOT NULL,
    pinyin_abbreviation VARCHAR(50) NOT NULL,
    cost_price DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Customer table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create CustomerProductPrice table
CREATE TABLE customer_product_prices (
    customer_id INTEGER REFERENCES customers(id),
    product_id INTEGER REFERENCES products(id),
    custom_price DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (customer_id, product_id)
);

-- Create Order table
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    total_amount DECIMAL(10, 2) NOT NULL,
    print_count INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create OrderItem table
CREATE TABLE order_items (
    id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES products(id),
    snapshot_name VARCHAR(255) NOT NULL,
    snapshot_price DECIMAL(10, 2) NOT NULL,
    quantity DECIMAL(10, 2) NOT NULL
);

-- Create indices for performance
CREATE INDEX idx_products_pinyin ON products(pinyin_abbreviation);
CREATE INDEX idx_orders_customer ON orders(customer_id);
CREATE INDEX idx_order_items_order ON order_items(order_id);

