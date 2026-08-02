-- -- ============================================
-- -- Query 7: Running Total of Revenue per Region
-- -- ============================================

WITH daily_revenue AS (

    SELECT

        o.region_code,

        DATE(o.order_date) AS order_date,

        ROUND(

            SUM(

                oi.quantity *
                oi.unit_price *
                (1 - oi.discount_percent / 100.0)

            ),

            2

        ) AS daily_revenue

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    GROUP BY

        o.region_code,
        DATE(o.order_date)

)

SELECT

    region_code,

    order_date,

    daily_revenue,

    ROUND(

        SUM(daily_revenue) OVER (

            PARTITION BY region_code

            ORDER BY order_date

            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW

        ),

        2

    ) AS running_total

FROM daily_revenue

ORDER BY

    region_code,
    order_date;

-- ============================================
-- Query 8: Ranking Products by Revenue
-- ============================================

WITH product_revenue AS (

    SELECT

        p.category,

        p.product_name,

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

        p.category,
        p.product_name

)

SELECT

    category,

    product_name,

    total_revenue,

    DENSE_RANK() OVER (

        PARTITION BY category

        ORDER BY total_revenue DESC

    ) AS rank_in_category

FROM product_revenue

ORDER BY

    category,
    rank_in_category,
    product_name;


-- ============================================
-- Query 9: LAG Analysis
-- ============================================

WITH customer_orders AS (

    SELECT

        customer_id,

        DATE(order_date) AS order_date,

        LAG(
            DATE(order_date)
        ) OVER (

            PARTITION BY customer_id

            ORDER BY DATE(order_date)

        ) AS previous_order_date

    FROM orders

),

order_gap AS (

    SELECT

        customer_id,

        order_date,

        previous_order_date,

        CAST(

            julianday(order_date) -
            julianday(previous_order_date)

            AS INTEGER

        ) AS days_gap

    FROM customer_orders

),

customer_status AS (

    SELECT

        customer_id,

        ROUND(

            AVG(days_gap),

            2

        ) AS average_gap

    FROM order_gap

    WHERE days_gap IS NOT NULL

    GROUP BY customer_id

)

SELECT

    og.customer_id,

    og.order_date,

    og.previous_order_date,

    og.days_gap,

    cs.average_gap,

    CASE

        WHEN cs.average_gap > 30
        THEN 'At Risk'

        ELSE 'Active'

    END AS customer_status

FROM order_gap og

LEFT JOIN customer_status cs

ON og.customer_id = cs.customer_id

ORDER BY

    og.customer_id,
    og.order_date;




-- ============================================
-- Query 10: Monthly Customer Segmentation
-- ============================================

WITH monthly_customer_revenue AS (

    SELECT

        strftime('%Y-%m', o.order_date) AS order_month,

        o.customer_id,

        ROUND(

            SUM(

                oi.quantity *
                oi.unit_price *
                (1 - oi.discount_percent / 100.0)

            ),

            2

        ) AS monthly_revenue

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    GROUP BY

        strftime('%Y-%m', o.order_date),

        o.customer_id

),

customer_category AS (

    SELECT

        order_month,

        customer_id,

        monthly_revenue,

        CASE

            WHEN monthly_revenue > 10000
            THEN 'High'

            WHEN monthly_revenue >= 5000
            THEN 'Medium'

            ELSE 'Low'

        END AS customer_category

    FROM monthly_customer_revenue

)

SELECT

    order_month,

    customer_category,

    COUNT(customer_id) AS total_customers

FROM customer_category

GROUP BY

    order_month,

    customer_category

ORDER BY

    order_month,

    CASE customer_category

        WHEN 'High' THEN 1
        WHEN 'Medium' THEN 2
        ELSE 3

    END;


-- ============================================
-- Query 11: Customer Segmentation using NTILE
-- ============================================

WITH customer_lifetime_value AS (

    SELECT

        o.customer_id,

        ROUND(

            SUM(

                oi.quantity *
                oi.unit_price *
                (1 - oi.discount_percent / 100.0)

            ),

            2

        ) AS total_value

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    GROUP BY
        o.customer_id

),

customer_quartiles AS (

    SELECT

        customer_id,

        total_value,

        NTILE(4) OVER (

            ORDER BY total_value DESC

        ) AS quartile

    FROM customer_lifetime_value

)

SELECT

    customer_id,

    total_value,

    quartile,

    CASE

        WHEN quartile = 1 THEN 'Platinum'

        WHEN quartile = 2 THEN 'Gold'

        WHEN quartile = 3 THEN 'Silver'

        ELSE 'Bronze'

    END AS quartile_label

FROM customer_quartiles

ORDER BY

    total_value DESC;


-- ============================================
-- Query 12: Year-over-Year Revenue Comparison
-- ============================================

WITH monthly_revenue AS (

    SELECT

        strftime('%Y', o.order_date) AS year,

        strftime('%m', o.order_date) AS month,

        ROUND(

            SUM(

                oi.quantity *
                oi.unit_price *
                (1 - oi.discount_percent / 100.0)

            ),

            2

        ) AS revenue

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    GROUP BY

        strftime('%Y', o.order_date),

        strftime('%m', o.order_date)

)

SELECT

    current.year,

    current.month,

    current.revenue,

    previous.revenue AS prev_year_revenue,

    ROUND((current.revenue - previous.revenue) * 100.0 / NULLIF(previous.revenue, 0), 2 ) AS yoy_growth_percent

FROM monthly_revenue current

LEFT JOIN monthly_revenue previous

ON current.month = previous.month

AND CAST(current.year AS INTEGER) =
    CAST(previous.year AS INTEGER) + 1

ORDER BY

    current.year,

    current.month;


-- ============================================
-- Query 13: First/Last Purchased Category
-- ============================================

WITH customer_categories AS (

    SELECT

        o.customer_id,

        o.order_date,

        p.category,

        FIRST_VALUE(p.category) OVER (

            PARTITION BY o.customer_id

            ORDER BY o.order_date ASC

        ) AS first_category,

        FIRST_VALUE(p.category) OVER (

            PARTITION BY o.customer_id

            ORDER BY o.order_date DESC

        ) AS last_category

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    JOIN products p
    ON oi.product_id = p.product_id

)

SELECT DISTINCT

    customer_id,

    first_category,

    last_category,

    CASE

        WHEN first_category = last_category
        THEN 'No'

        ELSE 'Yes'

    END AS category_shift

FROM customer_categories

ORDER BY customer_id;


-- ============================================
-- Query 14: Cumulative Revenue Distribution
-- ============================================

WITH customer_revenue AS (

    SELECT

        o.customer_id,

        ROUND(

            SUM(

                oi.quantity *
                oi.unit_price *
                (
                    1 - oi.discount_percent / 100.0
                )

            ),

            2

        ) AS revenue

    FROM orders o

    JOIN order_items oi
    ON o.order_id = oi.order_id

    GROUP BY
        o.customer_id

),

ranked_customers AS (

    SELECT

        customer_id,
        revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_revenue,
        ROUND(SUM(revenue) OVER ( ORDER BY revenue DESC ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) * 100.0 / SUM(revenue) OVER (), 2) AS cumulative_percent,

        ROUND(CUME_DIST() OVER (ORDER BY revenue DESC ) * 100, 2) AS customer_percent

    FROM customer_revenue

)

SELECT

    customer_id,

    revenue,

    cumulative_revenue,

    cumulative_percent,

    customer_percent

FROM ranked_customers

ORDER BY revenue DESC;

