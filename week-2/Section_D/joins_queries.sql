-- ShopEase E-Commerce Database
-- Section D: Joins & Relationships


-- Q19. INNER JOIN: each order with the customer's first_name and
--      last_name. Show: order_id, order_date, first_name,
--      last_name, total_amount.
SELECT o.order_id,
       o.order_date,
       c.first_name,
       c.last_name,
       o.total_amount
FROM orders o
INNER JOIN customers c
        ON o.customer_id = c.customer_id
ORDER BY o.order_id;


-- Q20. LEFT JOIN: ALL customers and their orders (if any).
--      Customers with no orders should still appear, with NULLs
--      for order columns.
SELECT c.customer_id,
       c.first_name,
       c.last_name,
       o.order_id,
       o.order_date,
       o.status,
       o.total_amount
FROM customers c
LEFT JOIN orders o
       ON c.customer_id = o.customer_id
ORDER BY c.customer_id;


-- Q21. 3-table JOIN (orders -> order_items -> products):
--      order_id, product_name, quantity, unit_price, discount_pct
--      for each order item.
SELECT oi.order_id,
       p.product_name,
       oi.quantity,
       oi.unit_price,
       oi.discount_pct
FROM orders o
JOIN order_items oi ON o.order_id   = oi.order_id
JOIN products    p  ON oi.product_id = p.product_id
ORDER BY oi.order_id;



-- Q22. Difference between LEFT JOIN and RIGHT JOIN, with an
--      example from this schema. When would you use FULL OUTER
--      JOIN?
--
-- LEFT JOIN:
--   Returns ALL rows from the LEFT (first-named) table, plus
--   matching rows from the right table. Unmatched right-table
--   columns come back as NULL.
--
--   Example: list every customer, with their orders if they have
--   any (customers with zero orders still appear):
--
    SELECT c.customer_id, c.first_name, o.order_id
    FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id;
--
-- RIGHT JOIN:
--   Returns ALL rows from the RIGHT (second-named) table, plus
--   matching rows from the left table. Unmatched left-table
--   columns come back as NULL. It is the mirror image of LEFT JOIN
--   — the same logical result can always be obtained by swapping
--   the table order and using LEFT JOIN instead.
--
--   Example: list every order along with its customer, even if
--   (hypothetically) an order's customer_id had no matching row in
--   customers (this can't actually happen here because of the FK
--   constraint, but illustrates the mechanics):
--
    SELECT c.customer_id, o.order_id
    FROM customers c
    RIGHT JOIN orders o ON c.customer_id = o.customer_id;
--
--   (Equivalent rewrite using LEFT JOIN:
    SELECT c.customer_id, o.order_id
    FROM orders o
    LEFT JOIN customers c ON o.customer_id = c.customer_id;
--
--   Note: MySQL and PostgreSQL both support RIGHT JOIN; some
--   engines (like SQLite before 3.39) only support LEFT JOIN, so
--   RIGHT JOIN is rewritten as a LEFT JOIN with table order swapped.
--
-- FULL OUTER JOIN
-- Returns all rows from both tables:
-- 1. Matching rows from both tables.
-- 2. Unmatched rows from the left table (right-side columns become NULL).
-- 3. Unmatched rows from the right table (left-side columns become NULL).
--
-- Useful when you want a complete view of data from both tables
-- and need to identify missing or unmatched records.
--
-- Example:
-- Customers: 1, 2, 3
-- Orders:    1, 2, 4
--
-- Result:
-- 1 ↔ 1    (Match)
-- 2 ↔ 2    (Match)
-- 3 ↔ NULL (Customer without an order)
-- NULL ↔ 4 (Order without a customer)
--
-- PostgreSQL / SQL Server:
--
-- SELECT c.customer_id, o.order_id
-- FROM customers c
-- FULL OUTER JOIN orders o
--     ON c.customer_id = o.customer_id;
--
-- MySQL does not support FULL OUTER JOIN directly.
-- It can be achieved using LEFT JOIN + RIGHT JOIN + UNION:
--
-- SELECT c.customer_id, o.order_id
-- FROM customers c
-- LEFT JOIN orders o
--     ON c.customer_id = o.customer_id
--
-- UNION
--
-- SELECT c.customer_id, o.order_id
-- FROM customers c
-- RIGHT JOIN orders o
--     ON c.customer_id = o.customer_id;
--
-- This returns:
-- • All matching records
-- • Customers without orders
-- • Orders without customers
--
-- Common Use Cases:
-- • Data auditing and reconciliation
-- • Finding orphan records
-- • Comparing data between two systems
-- • Checking missing relationships on both sides


-- Q23. Identify all Foreign Key relationships. What happens if
--      you insert an order with customer_id = 999 (doesn't exist)?
--
-- Foreign Key relationships in this schema:
--   orders.customer_id       -> customers.customer_id
--   order_items.order_id     -> orders.order_id
--   order_items.product_id   -> products.product_id
--
-- Attempted insert:
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
VALUES (9999, 999, '2024-09-01', 'Pending', 500.00);
--
-- What happens:
--   Since there is no row in `customers` where customer_id = 999,
--   the FOREIGN KEY constraint on orders.customer_id is violated.
--   The database rejects the INSERT and no row is added to
--   `orders`. This is referential integrity enforcement: it
--   prevents "dangling" foreign keys that point to records that
--   don't exist, which would otherwise corrupt downstream JOINs
--   and reports.
--
-- Actual error observed when tested:
--   Error: FOREIGN KEY constraint failed
--
-- (MySQL would report something equivalent, e.g.:
--   ERROR 1452 (23000): Cannot add or update a child row: a foreign
--   key constraint fails (`shopease`.`orders`, CONSTRAINT
--   `orders_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES
--   `customers` (`customer_id`)))