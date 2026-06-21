-- ShopEase E-Commerce Database
-- File: 02_create_indexes.sql
-- Description: Indexes to optimize common filter/sort queries

-- Speeds up filtering/joining customers by city
CREATE INDEX idx_customers_city ON customers(city);

-- Speeds up filtering/joining customers by state
CREATE INDEX idx_customers_state ON customers(state);

-- Speeds up filtering products by category (e.g. Section B, C queries)
CREATE INDEX idx_products_category ON products(category);

-- Speeds up date-range filtering and ORDER BY order_date
CREATE INDEX idx_orders_date ON orders(order_date);

-- Speeds up filtering orders by status (e.g. WHERE status = 'Delivered')
CREATE INDEX idx_orders_status ON orders(status);