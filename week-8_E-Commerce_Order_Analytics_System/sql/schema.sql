-- E-Commerce Order Analytics Database Schema

PRAGMA foreign_keys = ON;

-- Customers
CREATE TABLE IF NOT EXISTS customers (

    customer_id TEXT PRIMARY KEY,

    customer_name TEXT NOT NULL,

    email TEXT,

    registration_date DATE NOT NULL,

    customer_type TEXT NOT NULL
        CHECK (
            customer_type IN (
                'REGULAR',
                'PREMIUM',
                'VIP',
                'UNKNOWN'
            )
        )
);

-- Products
CREATE TABLE IF NOT EXISTS products (

    product_id TEXT PRIMARY KEY,

    product_name TEXT NOT NULL,

    category TEXT NOT NULL,

    subcategory TEXT NOT NULL,

    cost_price REAL NOT NULL
        CHECK (cost_price >= 0)
);

-- Orders
CREATE TABLE IF NOT EXISTS orders (

    order_id TEXT PRIMARY KEY,

    customer_id TEXT NOT NULL,

    order_date DATETIME NOT NULL,

    status TEXT NOT NULL
        CHECK (
            status IN (
                'PLACED',
                'SHIPPED',
                'DELIVERED',
                'CANCELLED',
                'RETURNED'
            )
        ),

    region_code TEXT NOT NULL,

    FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
);

-- Order Items
CREATE TABLE IF NOT EXISTS order_items (

    item_id TEXT PRIMARY KEY,

    order_id TEXT NOT NULL,

    product_id TEXT NOT NULL,

    quantity INTEGER NOT NULL,

    unit_price REAL NOT NULL
        CHECK (unit_price >= 0),

    discount_percent REAL NOT NULL
        CHECK (
            discount_percent >= 0
            AND discount_percent <= 100
        ),

    FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    FOREIGN KEY (product_id)
        REFERENCES products(product_id)
);