-- WEEK-3(Subqueries)
-- Step 2: Perform Required Queries 
-- Write and execute SQL queries for each of the following:
 
-- 1. Find all orders where sales are greater than the average sales. (Subquery)
select * from orders where sales > (select avg(sales) from orders);


-- 2. Find the highest sales order for each customer. (Subquery)  
SELECT 
    c.customer_id, 
    c.customer_name, 
    (SELECT MAX(o.sales) FROM orders o WHERE o.customer_id = c.customer_id) AS `Highest Sales`
FROM customers c;


-- 3. Calculate total sales for each customer. (CTE) 
with TotalSales as
	(SELECT o.customer_id, SUM(o.sales) AS `Total Sales` FROM orders o group by o.customer_id )
 SELECT 
    c.customer_id, 
    c.customer_name,
    ts.`Total Sales`
FROM customers c inner join TotalSales ts on c.customer_id =ts.customer_id;


-- 4. Find customers whose total sales are above average. (CTE + Subquery)  
with TotalSales as
	(SELECT o.customer_id, SUM(o.sales) AS `Total Sales` FROM orders o group by o.customer_id )
 SELECT 
    c.customer_id, 
    c.customer_name,
    ts.`Total Sales`
FROM customers c inner join TotalSales ts on c.customer_id =ts.customer_id where ts.`Total Sales` > (select avg(`Total Sales`) from TotalSales);


-- 5. Rank all customers based on total sales. (Window Function)  
WITH TotalSales AS (
    SELECT o.customer_id, SUM(o.sales) AS `Total Sales` 
    FROM orders o 
    GROUP BY o.customer_id 
)
SELECT 
    c.customer_id, 
    c.customer_name,
    COALESCE(ts.`Total Sales`, 0) AS `Total Sales`,
    DENSE_RANK() OVER(ORDER BY COALESCE(ts.`Total Sales`, 0) DESC) AS rnk
FROM customers c 
LEFT JOIN TotalSales ts ON c.customer_id = ts.customer_id; 


-- 6. Assign row numbers to each order within a customer. (Window Function + PARTITION BY)  
select order_id, order_date,
    customer_id, product_id_fk, 
    sales, quantity, discount, profit, ROW_NUMBER() OVER(partition by customer_id order by order_id) as Row_Num from orders;
    

-- 7. Display top 3 customers based on total sales. (Window Function)  
WITH TotalSales AS (
    SELECT o.customer_id, SUM(o.sales) AS `Total Sales` 
    FROM orders o 
    GROUP BY o.customer_id 
)
SELECT 
    c.customer_id, 
    c.customer_name,
    COALESCE(ts.`Total Sales`, 0) AS `Total Sales`,
    DENSE_RANK() OVER(ORDER BY COALESCE(ts.`Total Sales`, 0) DESC) AS rnk
FROM customers c 
LEFT JOIN TotalSales ts ON c.customer_id = ts.customer_id limit 3; 


-- Step 3: Final Combined Query (Use JOIN + CTE + Window Function together)
-- Write one final query that shows: 
-- Customer Name | Total Sales | Rank 

WITH TotalSales AS (
    SELECT o.customer_id, SUM(o.sales) AS `Total Sales` 
    FROM orders o 
    GROUP BY o.customer_id 
)
SELECT 
    c.customer_name,
    COALESCE(ts.`Total Sales`, 0) AS `Total Sales`,
    DENSE_RANK() OVER(ORDER BY COALESCE(ts.`Total Sales`, 0) DESC) AS rnk
FROM customers c 
LEFT JOIN TotalSales ts ON c.customer_id = ts.customer_id; 






