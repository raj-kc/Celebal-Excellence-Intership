-- ============================================================
-- ShopEase E-Commerce Database
-- Section E: Advanced Concepts (CASE, ACID, Transactions)
-- ============================================================


-- Q24. CASE: classify products into price tiers.
--      Budget    -> unit_price < 1000
--      Mid-Range -> unit_price BETWEEN 1000 AND 3000
--      Premium   -> unit_price > 3000
SELECT product_name,
       unit_price,
       CASE
           WHEN unit_price < 1000 THEN 'Budget'
           WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
           ELSE 'Premium'
       END AS price_tier
FROM products;

-- Result on sample data:
--   Wireless Earbuds      1499.00  Mid-Range
--   Cotton T-Shirt         799.00  Budget
--   Smart Watch           2999.00  Mid-Range
--   Running Shoes         4599.00  Premium
--   Bluetooth Speaker     3499.00  Premium
--   Bedsheet Set          1299.00  Mid-Range
--   Laptop Stand           899.00  Budget
--   Cushion Covers (Set)   599.00  Budget


-- Q25. CASE inside an aggregate: count 'Delivered' vs
--      'Not Delivered' orders, in a single row.
SELECT
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
    SUM(CASE WHEN status <> 'Delivered' THEN 1 ELSE 0 END) AS not_delivered_count
FROM orders;
-- Result on sample data:
--   delivered_count = 6   (Delivered)
--   not_delivered_count = 4   (Shipped x2, Cancelled x1, Pending x1)



-- Q26. Explain ACID, with a real-world bank transfer example.
--
-- ACID is the set of guarantees a database transaction provides to
-- ensure data stays reliable, even with concurrent users, crashes,
-- or power failures.
--
-- A — ATOMICITY
--   A transaction is "all or nothing." Every operation inside it
--   either fully completes, or none of it does.
--   Example: a bank transfer of 5000 from Account A to Account B
--   involves two steps: (1) debit 5000 from A, (2) credit 5000 to
--   B. If the system crashes after step 1 but before step 2,
--   atomicity ensures the WHOLE transaction is rolled back — A is
--   NOT left short by 5000 with B never receiving it. Without
--   atomicity, money could simply vanish.
--
-- C — CONSISTENCY
--   A transaction must take the database from one valid state to
--   another valid state, never violating defined rules/constraints
--   (e.g., CHECK, FOREIGN KEY, business rules).
--   Example: if a business rule says "an account balance can never
--   go negative," consistency ensures that the transfer is rejected
--   (or rolled back) if debiting 5000 from Account A would push its
--   balance below zero, rather than allowing the database to enter
--   an invalid state.
--
-- I — ISOLATION
--   Concurrent transactions should not interfere with each other;
--   each transaction should behave as if it were running alone,
--   even if many run at the same time.
--   Example: if two transfers FROM Account A happen at the exact
--   same moment (one withdrawing 3000, another withdrawing 4000,
--   on a balance of 5000), isolation ensures the database processes
--   them safely — e.g., by serializing access to A's balance — so
--   the final balance correctly reflects both withdrawals rather
--   than one overwriting the other's update (this is what prevents
--   a "double-spend" type bug).
--
-- D — DURABILITY
--   Once a transaction is committed, its effects are permanent,
--   even if the system crashes immediately afterward (it survives
--   power loss, crashes, etc., because it's been written to
--   persistent storage).
--   Example: once the bank transfer is committed and the customer
--   sees "Transfer Successful," that result must hold even if the
--   server crashes one second later. The customer should never log
--   back in and find their successfully transferred money missing
--   or duplicated because of a crash that happened after commit.


-- Q27. Transaction: insert a new order, insert two order items,
--      update stock_qty for purchased products, atomically.
--      ROLLBACK on any failure, otherwise COMMIT.


-- This example uses product_id 206 (Bedsheet Set) and 208
-- (Cushion Covers Set) as the two items purchased, matching the
-- order's total_amount of 1598.00 (= 1299.00 + 599.00 - rounding;
-- adjust quantities/discounts to match your own total_amount if
-- you change the products used).

DELIMITER //

CREATE PROCEDURE create_order()
BEGIN

    -- If any SQL error occurs, rollback transaction
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SELECT 'Transaction Failed - All Changes Rolled Back' AS Message;
    END;

    START TRANSACTION;

    -- Step 1: Create Order
    INSERT INTO orders
    (order_id, customer_id, order_date, status, total_amount)
    VALUES
    (1011, 102, CURDATE(), 'Pending', 1598.00);

    -- Step 2: Add First Item
    INSERT INTO order_items
    (item_id, order_id, product_id, quantity, unit_price, discount_pct)
    VALUES
    (5016, 1011, 206, 1, 1299.00, 0);

    -- Step 3: Add Second Item
    INSERT INTO order_items
    (item_id, order_id, product_id, quantity, unit_price, discount_pct)
    VALUES
    (5017, 1011, 208, 1, 599.00, 0);

    -- Step 4: Update Product Stock
    UPDATE products
    SET stock_qty = stock_qty - 1
    WHERE product_id = 206;

    UPDATE products
    SET stock_qty = stock_qty - 1
    WHERE product_id = 208;

    -- Save all changes permanently
    COMMIT;

    SELECT 'Transaction Successful' AS Message;

END //

DELIMITER ;

-- ------------------------------------------------------------
-- Procedure: create_order()
--
-- Purpose:
-- Creates an order, adds order items, and updates product
-- stock within a single transaction.
--
-- Working:
-- 1. START TRANSACTION begins the transaction.
-- 2. A new order and its items are inserted.
-- 3. Product stock is updated.
-- 4. If all statements succeed, COMMIT saves all changes.
-- 5. If any SQL error occurs, the SQLEXCEPTION handler
--    automatically executes ROLLBACK and undoes all changes.
--
-- Success Flow:
-- Start Transaction → Insert Order → Insert Items
-- → Update Stock → COMMIT
--
-- Failure Flow:
-- Start Transaction → Error Occurs
-- → ROLLBACK → All Changes Undone
--
-- ACID Property:
-- Atomicity - Either all operations succeed together,
-- or none of them are saved.
-- ------------------------------------------------------------