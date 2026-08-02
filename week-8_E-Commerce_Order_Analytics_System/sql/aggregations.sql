-- ============================================
-- Query 1: Total Revenue Per Category
-- ============================================

SELECT
    p.category,

    ROUND(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100.0)
        ),
        2
    ) AS total_revenue

FROM products p

JOIN order_items oi
ON p.product_id = oi.product_id

GROUP BY
    p.category

ORDER BY
    total_revenue DESC;

-- ============================================
-- Query 2: Top 10 Customers by Total Order Value
-- ============================================

SELECT
    c.customer_id,
    c.customer_name,

    ROUND(
        SUM(
            oi.quantity *
            oi.unit_price *
            (1 - oi.discount_percent / 100.0)
        ),
        2
    ) AS total_order_value

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

JOIN order_items oi
ON o.order_id = oi.order_id

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY
    total_order_value DESC

LIMIT 10;


-- ============================================
-- Query 3: Month-wise Order Count for Last 12 Months
-- ============================================

SELECT
    strftime('%Y-%m', order_date) AS order_month,

    COUNT(order_id) AS total_orders

FROM orders

WHERE order_date >= date(
    (SELECT MAX(order_date) FROM orders),
    '-12 months'
)

GROUP BY
    strftime('%Y-%m', order_date)

ORDER BY
    order_month;


-- ============================================
-- Query 4: Customers with orders but no delivered items
-- ============================================

SELECT
    c.customer_id,
    c.customer_name

FROM customers c

JOIN orders o
ON c.customer_id = o.customer_id

LEFT JOIN order_items oi
ON o.order_id = oi.order_id

WHERE NOT EXISTS (

    SELECT 1

    FROM orders o2

    JOIN order_items oi2
    ON o2.order_id = oi2.order_id

    WHERE o2.customer_id = c.customer_id
    AND o2.status = 'DELIVERED'
)

GROUP BY
    c.customer_id,
    c.customer_name

ORDER BY
    c.customer_id;

-- -- ============================================
-- -- Query 5: Products with more returns than purchases
-- -- ============================================

SELECT

    p.product_id,
    p.product_name,

    SUM(
        CASE 
            WHEN oi.quantity > 0 
            THEN oi.quantity
            ELSE 0
        END
    ) AS total_purchased,


    ABS(
        SUM(
            CASE 
                WHEN oi.quantity < 0 
                THEN oi.quantity
                ELSE 0
            END
        )
    ) AS total_returned


FROM products p


JOIN order_items oi

ON p.product_id = oi.product_id


GROUP BY

    p.product_id,
    p.product_name


HAVING

    total_returned > total_purchased


ORDER BY

    total_returned DESC;

-- ============================================
-- Query 6: Return Rate per Category
-- ============================================
SELECT
    p.category,
    SUM(
        CASE
            WHEN oi.quantity < 0 THEN ABS(oi.quantity)
            ELSE 0
        END
    ) AS returned_items,
    SUM(ABS(oi.quantity)) AS total_items,
    ROUND(
        CAST(
            SUM(
                CASE
                    WHEN oi.quantity < 0 THEN ABS(oi.quantity)
                    ELSE 0
                END
            ) AS REAL
        ) / SUM(ABS(oi.quantity)) * 100,
        2
    ) AS return_rate_percent
FROM products p
JOIN order_items oi
ON p.product_id = oi.product_id
GROUP BY p.category;