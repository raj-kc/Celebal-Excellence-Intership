-- ShopEase E-Commerce Database
-- Section C: Aggregation (GROUP BY, SUM, COUNT, AVG, MIN, MAX)


-- Q13. Count the total number of orders in the orders table.
SELECT COUNT(*) AS total_orders
FROM orders;
-- Result on sample data: 10


-- Q14. Find the total revenue (SUM of total_amount) from all
--      'Delivered' orders.
SELECT SUM(total_amount) AS total_revenue
FROM orders
WHERE status = 'Delivered';
-- Result on sample data: 17191.00


-- Q15. Calculate the average unit_price of products in each
--      category.
SELECT category,
       ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM products
GROUP BY category;
-- Result on sample data:
--   Clothing    -> 2699.00
--   Electronics -> 2224.00
--   Home        -> 949.00


-- Q16. For each order status, find the count of orders and the
--      total revenue. Sort by total revenue descending.
SELECT status,
       COUNT(*)          AS order_count,
       SUM(total_amount) AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;
-- Result on sample data:
--   Delivered  -> 6 orders, 17191.00
--   Shipped    -> 2 orders, 13596.00
--   Cancelled  -> 1 order,   2999.00
--   Pending    -> 1 order,   1299.00


-- Q17. Find the most expensive (MAX) and cheapest (MIN) product
--      in each category.
SELECT category,
       MAX(unit_price) AS most_expensive_price,
       MIN(unit_price) AS cheapest_price
FROM products
GROUP BY category;
-- Result on sample data:
--   Clothing    -> max 4599.00 (Running Shoes), min 799.00 (Cotton T-Shirt)
--   Electronics -> max 3499.00 (Bluetooth Speaker), min 899.00 (Laptop Stand)
--   Home        -> max 1299.00 (Bedsheet Set), min 599.00 (Cushion Covers)

-- Optional extended version that also names the actual product
-- (since plain MAX/MIN only return the price, not which product):
SELECT p.category,
       p.product_name,
       p.unit_price
FROM products p
WHERE (p.category, p.unit_price) IN (
    SELECT category, MAX(unit_price) FROM products GROUP BY category
)
OR (p.category, p.unit_price) IN (
    SELECT category, MIN(unit_price) FROM products GROUP BY category
)
ORDER BY p.category, p.unit_price;


-- ------------------------------------------------------------
-- Q18. List all product categories where the average unit_price
--      is greater than 2000. (Use HAVING)
-- ------------------------------------------------------------
SELECT category,
       AVG(unit_price) AS avg_unit_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000;
-- Result on sample data:
--   Clothing    -> 2699.00
--   Electronics -> 2224.00
-- (Home is excluded since its average is 949.00)
--
-- Note: HAVING filters groups AFTER aggregation, whereas WHERE
-- filters individual rows BEFORE aggregation. You cannot write
-- "WHERE AVG(unit_price) > 2000" because AVG() doesn't exist yet
-- at the row-filtering stage.