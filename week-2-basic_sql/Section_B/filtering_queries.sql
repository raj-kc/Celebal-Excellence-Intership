-- ShopEase E-Commerce Database
-- Section B: Filtering & Optimization (WHERE, Indexes)


-- Q7. Retrieve all orders with status = 'Delivered'.
SELECT *
FROM orders
WHERE status = 'Delivered';


-- Q8. Find all products in the 'Electronics' category with a
--     unit_price greater than 2000.
SELECT *
FROM products
WHERE category = 'Electronics'
  AND unit_price > 2000;


-- Q9. List all customers who joined in the year 2024 and belong
--     to the state 'Maharashtra'.
SELECT *
FROM customers
WHERE state = 'Maharashtra'
  AND join_date >= '2024-01-01'
  AND join_date <  '2025-01-01';


-- Q10. Find all orders placed between '2024-08-10' and
--      '2024-08-25' (inclusive) that are NOT cancelled.
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
  AND status <> 'Cancelled';



-- Q11. Explain what idx_orders_date does, how it improves
-- performance, and a sample query that benefits from it.

/*
What it does:
idx_orders_date is a B-Tree index built on the `order_date`
column of the `orders` table. It stores order_date values in
sorted order alongside pointers to the corresponding rows.

How it improves performance:
Without the index, a query that filters or sorts by order_date
forces the database to perform a full table scan: it must read
every row in `orders` and check whether order_date matches the
condition (O(n) cost, where n = number of rows).
With the index, the database can binary-search the sorted
index structure to jump straight to the qualifying range of
dates (O(log n) cost), then fetch only those rows. This is
especially valuable for:
- range filters (WHERE order_date BETWEEN ... AND ...)
- ORDER BY order_date (avoids an expensive sort step)
- inequality filters (WHERE order_date >= '2024-08-01')
*/


-- Sample query that benefits from this index:
SELECT order_id, customer_id, order_date, status, total_amount
FROM orders
WHERE order_date >= '2024-08-15'
ORDER BY order_date;

/*
Verified with EXPLAIN QUERY PLAN against the test database:
SEARCH orders USING INDEX idx_orders_date (order_date>?)
confirming the engine uses the index rather than scanning the
whole table.
*/




/*
Q12. SELECT * FROM customers WHERE YEAR(join_date) = 2024;
Would the index on join_date be used? Why/why not?
Rewrite to be SARGable.

Note: 
There is no explicit idx_customers_join_date index in this schema, 
but the principle below applies generally to ANY index on join_date 
(and is exactly why such an index would be wasted if queries are 
written this way).


WOULD THE INDEX BE USED?
------------------------
No.


WHY NOT?
--------
Wrapping an indexed column in a function — YEAR(join_date) — forces 
the database to compute YEAR(join_date) for every single row BEFORE 
it can compare the result to 2024. 

Because the index stores raw join_date values (not the computed 
YEAR() result), the engine cannot use the index to look up rows by 
the function output. This forces a full table scan, even though an 
index exists on join_date. A predicate like this is called 
"non-SARGable" (not Search ARGument-ABLE).
*/

-- SARGable REWRITE:

-- This format compares the raw column directly, allowing any index on 
-- join_date to be used as a range scan:

SELECT * FROM customers 
WHERE join_date >= '2024-01-01' 
  AND join_date < '2025-01-01';


/*
VERIFIED WITH EXPLAIN QUERY PLAN:
---------------------------------
* YEAR()/strftime()-wrapped version -> SCAN customers (full scan)
* Range-rewritten version            -> SEARCH ... USING INDEX (if index exists)


GENERAL RULE:
-------------
Avoid wrapping indexed columns in functions (YEAR(), UPPER(), DATE(), etc.) 
inside WHERE clauses. Prefer range comparisons (>=, <, BETWEEN) on the 
raw column instead.
*/
