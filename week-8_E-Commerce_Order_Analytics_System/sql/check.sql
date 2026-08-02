-- -- ============================================
-- -- Query 10: Monthly Revenue Growth
-- -- ============================================

-- WITH monthly_revenue AS (

--     SELECT

--         strftime('%Y-%m', o.order_date) AS order_month,

--         ROUND(
--             SUM(
--                 oi.quantity *
--                 oi.unit_price *
--                 (1 - oi.discount_percent / 100.0)
--             ),
--             2
--         ) AS revenue

--     FROM orders o

--     JOIN order_items oi
--     ON o.order_id = oi.order_id

--     GROUP BY strftime('%Y-%m', o.order_date)

-- ),

-- previous_month AS (

--     SELECT

--         order_month,

--         revenue,

--         LAG(revenue) OVER (
--             ORDER BY order_month
--         ) AS previous_revenue

--     FROM monthly_revenue

-- )

-- SELECT

--     order_month,

--     revenue,

--     previous_revenue,

--     ROUND(
--         (
--             revenue - previous_revenue
--         )
--         /
--         NULLIF(previous_revenue, 0)
--         * 100,
--         2
--     ) AS growth_percent

-- FROM previous_month

-- ORDER BY order_month;


SELECT ROUND(( 100 - 50 ) / NULLIF(50, 0) * 100, 2);