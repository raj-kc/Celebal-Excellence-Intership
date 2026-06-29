-- WEEK-3(Subqueries)
-- Mini Project
-- Write and execute SQL queries for each of the following:
-- Mini Project: Customer Sales Insights 
-- Answer the following using SQL: 


-- 1. Who are the top 5 customers?  
WITH RankedSales AS (
    SELECT 
		c.customer_id,
        c.customer_name,
        SUM(o.sales) AS `Total Sales`,
        DENSE_RANK() OVER (ORDER BY SUM(o.sales) DESC) AS rnk
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM RankedSales
WHERE rnk <= 5;


-- 2. Who are the bottom 5 customers?  
WITH RankedSales AS (
    SELECT 
		c.customer_id,
        c.customer_name,
        SUM(o.sales) AS `Total Sales`,
        DENSE_RANK() OVER (ORDER BY SUM(o.sales) ASC) AS rnk
    FROM customers c
    INNER JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT *
FROM RankedSales
WHERE rnk <= 5;


-- 3. Which customers made only one order?  
SELECT * 
FROM customers 
WHERE customer_id IN (
    SELECT customer_id 
    FROM orders 
    GROUP BY customer_id 
    HAVING COUNT(DISTINCT order_id) = 1
);

-- 4. Which customers have above-average sales?  
with TotalSales as
	(SELECT o.customer_id, SUM(o.sales) AS `Total Sales` FROM orders o group by o.customer_id )
 SELECT 
    c.customer_id, 
    c.customer_name,
    ts.`Total Sales`
FROM customers c inner join TotalSales ts on c.customer_id =ts.customer_id where ts.`Total Sales` > (select avg(`Total Sales`) from TotalSales);


-- 5. What is the highest order value per customer? 

WITH OrderTotals AS (
    SELECT 
        o.customer_id, 
        o.order_id, 
        SUM(o.sales) AS total_order_value
    FROM orders o
    GROUP BY o.customer_id, o.order_id
)
SELECT 
    c.customer_id, 
    c.customer_name, 
    MAX(ot.total_order_value) AS `Highest Order Value`
FROM customers c
INNER JOIN OrderTotals ot ON c.customer_id = ot.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY `Highest Order Value` DESC;
